# Sprint Awesome

This is the final project made during the 9 week [Le Wagon coding bootcamp](https://www.lewagon.com).
The idea was to create a data visualisation tool for project managers during concentrated periods of development, or **Sprints**.

### Our product link
[Sprint Awesome](https://www.sprintawesome.xyz)

#### The Live Demo-day Recording
Ours starts at *26:05*, link should start there automatically.

[![Demo-day live recording](http://img.youtube.com/vi/RapAsDeoog8/0.jpg)](https://youtu.be/RapAsDeoog8?t=1301)

Essentially an add-on to Trello. Trello is an awesome tool for organization. Not just aimed at developers, but everybody.
Seriously, [check it out](http://www.trello.com/).

#### Gems worth mentioning, beyond the minimal install

```ruby
gem 'devise'
gem 'omniauth-trello'
gem 'ruby-trello'
gem 'groupdate'
gem 'chartkick'
gem 'httparty'
```
`Devise` and the `omniauth-trello` implementation were the first ones we had to learn to work with. It was critical at the beginning, for the possibility of moving forward with the idea, to be able to access a user's Trello account from our app. Then to start working on transferring over the user's board information and build visual representations of the data in it.

`Httparty` and `ruby-trello` were used to communicate with the Trello [API](https://developers.trello.com/).

`Groupdate` and `chartkick` were needed for displaying the data.


## Schema

Here is a link to the Schema as of this moment, a lot of alterations were made due to the nature of the project, we didn't really know what we were doing but in the end we decided on persisting in our server DB only the minimum required for the data we were gathering. The later tables on `sprint_stats` and `member_stats` are the actual long ones. They are made out of instance methods on the `Sprint` and `Member` models, and are called and stored through the API wrapper, everytime something is updated. With these we can build out visualisation of statistics over time, such as the Burndown chart.

![alt text](https://github.com/mlrcbsousa/trello-project/blob/master/db-schema.png "DB Schema")

If you do find anything missing or not functioning as you expect it
to, please [let us know](https://github.com/mlrcbsousa/trello-project/issues/new).


#### 2-legged OAuth authorization

After logging a user in and persisting his token and secret, we use the `ruby-trello` gem functionality with the `User` instance method `client` which configures a client with the remaining information required to build the http requests to the Trello API.

```ruby
# app/models/user.rb

# create a client with ruby-trello gem to make requests to trello api
def client
  @client ||= Trello::Client.new(
    consumer_key: ENV['TRELLO_KEY'],
    consumer_secret: ENV['TRELLO_SECRET'],
    oauth_token: token,
    oauth_token_secret: secret
  )
end
```

All the calls this library makes to Trello require authentication using these keys. Be sure to protect them.


#### Boards

We created the boards model purely as a funcitonality model, in between getting the array of `idBoards` form the omniauth response, and showing those same boards in the `pick` stage of the onboarding process as embedded boards with the Trello formatting.


#### Onboarding Process

A big chunk of the initial development of the app was spent around building the `onboarding` logic of the app. What where we going to ask from the user to build stats on his Trello board? The `new` route is a `POST` because it sends information from the `pick` stage which are `boards` in hidden form using `hidden_field_tag`.

```ruby
# Onboarding
get 'onboard/pick', to: 'onboard#pick', as: 'pick'
post 'sprints/new', to: 'sprints#new', as: 'new'
get 'conversions/new/:id', to: 'conversions#new', as: 'new_conversion'
post 'conversions/:id', to: 'conversions#create', as: 'conversions'
get 'onboard/contribute/:id', to: 'onboard#contribute', as: 'contribute'
patch 'onboard/schedule/:id', to: 'onboard#schedule', as: 'schedule'
patch 'onboard/complete/:id', to: 'onboard#complete', as: 'complete'
```
The `create sprint` button on the `'sprints#new'` page is the set-off for the whole amount of requests to the Trello API needed for the specific case...

```ruby
# app/controllers/sprints_controller.rb

def create
  @sprint = Sprint.new(sprint_params)
  @sprint.user = current_user
  if @sprint.save
    # check if that sprint board is already setup in the app by another user
    webhook = Webhook.find_by(ext_board_id: @sprint.trello_ext_id)
    webhook ? @sprint.update(webhook: webhook) : @sprint.create_webhook
    TrelloAPI.new(sprint: @sprint)
    redirect_to new_conversion_path(@sprint)
  else
    render :new, alert: 'Unable to create your sprint!'
  end
end
```
it takes the longest, depending on how much information on the Trello Board. We thought about postponing it in a *Background* job, but after the onboarding is complete, that information is required to display it in the `sprints/show.html.erb` so it's not something that can be waited on or that isn't central to the flow of our app.


#### Webhook

The webhook needed some logic to stop it from being created everytime a diferent user of the same board on Trello set it up as a **Sprint** on our app. Avoiding the situation of Trello sending the same update information *X* amount of times for *X* amount of users that set up the same board on the app. This assumes the webhook callback logic updates all sprints setup for that `idBoard`, which it does:

```ruby
# app/controllers/webhooks_controller.rb
def receive
  sprints = Sprint.where(trello_ext_id: params[:model][:id])
  event = params[:event][:type]
  EVENTS.each { |model, events| sprints.each { |sprint| trello(sprint, model) } if events.include?(event) }
end
```
The webhook creation logic also needed some `HTTParty` gem usage outside the `ruby-trello` functionality and this created some bugs whenever the logic was too deep...

```ruby
# app/models/sprint.rb
def create_webhook
  post_webhook
  update(webhook: Webhook.create!(ext_board_id: trello_ext_id))
end

# sends post request for creation of webhook on trello
def post_webhook
  HTTParty.post(
    "https://api.trello.com/1/tokens/#{user.token}/webhooks/?key=#{ENV['TRELLO_KEY']}",
    query: {
      description: "Sprint webhook user#{user.id}",
      callbackURL: "#{ENV['BASE_URL']}webhooks",
      idModel: trello_ext_id
    },
    headers: { "Content-Type" => "application/json" }
  )
end
```
If we tried to save the `post_webhook` instance method response and build a `Webhook` instance out of it stuff would break, timeout errors would occur and no webhooks would be created, remotely on Trello, which was central to the app.


#### Services & Middleware

This leads me to the **services** and **middleware** setup on the app.

The webhook payload from Trello comes with an `action` key that is overidden by the rails default `controller#action` default key pair in `params`. This is one of those things, like a few others in this app that were outside our comfort zone or *knowledge zone* and isn't quite fully understood but it works.

```ruby
# lib/middlewares/trello_payload_handler.rb
def call(env)
  params = env["rack.input"].gets
  if params && params["action"]
    result = JSON.parse(params)
    if result["action"]
      result["event"] = result["action"]
      result.delete("action")
      env["action_dispatch.request.request_parameters"] = result
    end
  end
  @app.call(env)
end
```

##### TrelloAPI

Our wrapper class, mostly uses the `ruby-trello` functionality, other Trello API logic is spread around the app in the `user` and `sprint` model and `sprints` and `onboard` controller.

It mostly centers around building get requests to Trello. But in terms of persistence on our server databse it parses the internal app action trigger between updating and creating. Creating for the `onboard` stage and updating for the `update` stage, which was initially living in the `updates_controller` but then moved to the `webhooks_controller` after we figured out how to make that work.

```ruby
# app/services/trello_api
METHODS = %i[members lists cards]

# @sprint, @type, @model
def initialize(attrs = { type: :onboard, model: :sprint })
  attrs.each { |k, v| instance_variable_set :"@#{k}", v }
  @ext_board = @sprint.user.client.find(:boards, @sprint.trello_ext_id)
  @type == :update ? parse : sprint
end

def parse
  Snapshot.new(sprint: @sprint, description: "before update #{@model}")
  send @model
  Snapshot.new(sprint: @sprint, description: "after update #{@model}")
end
```

##### Snapshot

`Snapshot.rb` runs the full gamet of `sprint` and `member` instance methods that generate data to be visualized and adds a timestamp and description to it. The reason to use a `datetime_at_post` is for the eventuality of building out background jobs for these snapshots in order to get a more accurate *time of order sent* rather then *time of job started* saved in the default `created_at` and `updated_at` in Active Record.

```ruby
# app/services/snapshot.rb
def sprint_stats
  attrs = SPRINT_STATS.each_with_object({}) { |method, hash| hash[method] = @sprint.send method }
  attrs[:datetime_at_post] = @datetime_at_post
  attrs[:description] = @description
  @sprint.sprint_stats.create!(attrs)
end
```

## The Sprint Model

... Is too long, need to figure out how to make it less crazy...


## Contributing

Several ways you can contribute. Documentation, code, tests, feature requests, bug reports.
