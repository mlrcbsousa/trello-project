class User < ApplicationRecord
  require 'trello'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:trello]

  # Associations
  has_many :sprints, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :webhooks

  # Validations
  validates :username,
            length: { in: 0..20 },
            allow_blank: false,
            # must be a word character (letter, number, underscore)
            format: { with: /\A(\w+)\z/ }

  # must be a-z or ' ' (case-insensitive)
  validates :full_name, allow_blank: false, format: { with: /\A([a-z \'\.']+)\z/i }
  validates :provider, :uid, :token, :secret, presence: true

  # login with trello
  def self.from_trello_omniauth(auth)
    user_params = user_params(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    # user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end
    return user
  end

  # build user_params from omniauth response
  def self.user_params(auth)
    user_params = auth.slice(:provider, :uid)
    raw_info = auth.extra.raw_info
    user_params.merge! raw_info.slice(:email, :username)
    user_params[:trello_avatar_url] = "https://trello-avatars.s3.amazonaws.com/#{raw_info.avatarHash}/170.png"
    user_params[:full_name] = raw_info.fullName
    user_params.merge! auth.credentials.slice(:token, :secret)
    user_params.to_h
  end

  # ------------
  # boards
  # argument is an array
  def create_boards(ext_board_ids)
    # destroy local if not in remote
    clean_boards(ext_board_ids)
    ext_board_ids.each do |ext_id|
      ext_board = client.find(:boards, ext_id)
      board = boards.find_by(trello_ext_id: ext_id)
      board ? update_board(board, ext_board) : create_board(ext_board)
    end
  end

  def clean_boards(ext_board_ids)
    to_clean = boards.pluck(:trello_ext_id) - ext_board_ids
    to_clean.each { |ext_id| boards.find_by(trello_ext_id: ext_id).destroy } unless to_clean.empty?
  end

  def update_board(board, ext_board)
    board.update!(name: ext_board.name, trello_url: ext_board.url)
  end

  def create_board(ext_board)
    boards.create!(trello_ext_id: ext_board.id, name: ext_board.name, trello_url: ext_board.url)
  end
  # ------------

  # create a client with ruby-trello gem to make requests to trello api
  def client
    @client ||= Trello::Client.new(
      consumer_key: ENV['TRELLO_KEY'],
      consumer_secret: ENV['TRELLO_SECRET'],
      oauth_token: token,
      oauth_token_secret: secret
    )
  end

  # lists the user's webhooks on trello
  def trello_webhooks
    HTTParty.get("https://api.trello.com/1/tokens/#{token}/webhooks/?key=#{ENV['TRELLO_KEY']}")
  end

  # takes a string as an argument
  def delete_wh_by_ext_id(trello_webhook_id)
    HTTParty.delete(
      "https://api.trello.com/1/webhooks/#{trello_webhook_id}?key=#{ENV['TRELLO_KEY']}&token=#{token}"
    )
  end

  # takes a sprint as an argument
  def delete_wh_by_sprint(sprint)
    trello_webhook_id = trello_webhooks.select { |webhook| webhook["idModel"] = sprint.trello_ext_id }[0]["id"]
    delete_wh_by_ext_id(trello_webhook_id)
  end

  # helper method, for use in console
  def delete_all_webhooks
    trello_webhooks.each { |webhook| delete_wh_by_ext_id(webhook["id"]) }
  end
end
