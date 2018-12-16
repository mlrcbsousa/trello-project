class Onboard
  ONBOARD = %i[webhook members lists cards]

  def initialize(sprint, ext_board)
    @sprint = sprint
    @cards = ext_board.cards
    @lists = ext_board.lists
    @members = ext_board.members
    ONBOARD.each { |method| send method }
  end

  def members
    @members.each do |member|
      Member.create!(
        trello_ext_id: member.id,
        sprint: @sprint,
        full_name: member.full_name,
        trello_avatar_url: @sprint.user.client.find(:member, member.id).avatar_url
      )
    end
  end

  def webhook
    confirmation = @sprint.webhook_post
    # create an save a Webhook record to our own database
    # using the info describing our new Trello Webhook!
    # this part isnt working, not saving anything
    Webhook.create!(
      description: confirmation["description"],
      active: true,
      callback_url: confirmation["callbackURL"],
      trello_ext_id: confirmation["id"],
      sprint: @sprint
    )
  end

  def lists
    @lists.each_with_index do |list, i|
      List.create!(
        # discounts first 2 rows for progress
        rank: (i.positive? ? i - 1 : 0),
        name: list.name,
        trello_ext_id: list.id,
        sprint: @sprint
      )
    end
  end

  def cards
    @cards.each do |card|
      last = card.name.split(/\b/)[-1].downcase
      size = %w[xs s m l xl xxl].include?(last) ? :"#{last}" : :o
      Card.create!(
        list: List.find_by(trello_ext_id: card.list.id),
        trello_ext_id: card.id,
        size: size,
        member: Member.find_by(trello_ext_id: card.member_ids.first)
      )
    end
  end
end
