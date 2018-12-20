class TrelloAPI
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

  def sprint
    METHODS.each { |method| send method }
  end

  def clean(model)
    internal = @sprint.send(model)
    to_clean = internal.pluck(:trello_ext_id) - @ext_board.send(model).map(&:id)
    to_clean.each { |ext_id| internal.find_by(trello_ext_id: ext_id).destroy } unless to_clean.empty?
  end

  # Members
  def members
    # destroy local if not in remote
    clean(:members)
    @ext_board.members.each do |ext_member|
      member = @sprint.members.find_by(trello_ext_id: ext_member.id)
      member ? update_member(member, ext_member) : member(ext_member)
    end
  end

  def update_member(member, ext_member)
    member.update!(
      full_name: ext_member.full_name,
      trello_avatar_url: @sprint.user.client.find(:member, ext_member.id).avatar_url
    )
  end

  def member(ext_member)
    @sprint.members.create!(
      trello_ext_id: ext_member.id,
      full_name: ext_member.full_name,
      trello_avatar_url: @sprint.user.client.find(:member, ext_member.id).avatar_url
    )
  end

  # Cards
  def card_size(ext_card)
    last = ext_card.name.split(/\b/)[-1].downcase
    %w[xs s m l xl xxl].include?(last) ? :"#{last}" : :o
  end

  def cards
    # destroy local if not in remote
    clean(:cards)
    @ext_board.cards.each do |ext_card|
      card = @sprint.cards.find_by(trello_ext_id: ext_card.id)
      size = card_size(ext_card)
      card ? update_card(card, ext_card, size) : card(ext_card, size)
    end
  end

  def update_card(card, ext_card, size)
    card.update!(
      list: @sprint.lists.find_by(trello_ext_id: ext_card.list.id),
      size: size,
      member: @sprint.members.find_by(trello_ext_id: ext_card.member_ids.first)
    )
  end

  def card(ext_card, size)
    Card.create!(
      list: @sprint.lists.find_by(trello_ext_id: ext_card.list.id),
      trello_ext_id: ext_card.id,
      size: size,
      member: @sprint.members.find_by(trello_ext_id: ext_card.member_ids.first)
    )
  end

  # Lists
  def lists
    # destroy local if not in remote
    clean(:lists)
    @ext_board.lists.each_with_index do |ext_list, ind|
      list = @sprint.lists.find_by(trello_ext_id: ext_list.id)
      list ? update_list(list, ext_list, ind) : list(ext_list, ind)
    end
  end

  def list(ext_list, ind)
    @sprint.lists.create!(
      # discounts first 2 rows for progress
      rank: (ind.positive? ? ind - 1 : 0),
      name: ext_list.name,
      trello_ext_id: ext_list.id
    )
  end

  def update_list(list, ext_list, ind)
    list.update!(
      rank: (ind.positive? ? ind - 1 : 0),
      name: ext_list.name
    )
  end
end
