class SprintsController < ApplicationController
  before_action :set_sprint, only: %i[show trello]
  layout 'onboarding', only: %i[new pick]

  def index
    @sprints = current_user.sprints
  end

  def new
    @name = params[:name]
    @trello_ext_id = params[:trello_ext_id]
    @trello_url = params[:trello_url]
    @sprint = Sprint.new
  end

  def show
    # total man hours
    @man_hours = @sprint.man_hours

    # total cards
    @total_cards = @sprint.cards.count

    # cards per size
    @cards_per_size = @sprint.cards.group(:size).count

    # cards per member
    assigned = @sprint.cards.group(:member).count
                      .select { |key, _value| key.contributor if key.respond_to?(:contributor) }
                      .transform_keys(&:full_name)
    @cards_per_member = assigned.merge!('Unassigned' => (@sprint.cards.count - assigned.values.sum))

    # total story points
    @total_story_points = @sprint.cards.pluck(:size).map { |size| Card.sizes[size] }.sum

    # story points per member
    assigned = @sprint.members.where(contributor: true)
                      .map { |member| [member.full_name, member.cards.pluck(:size).map { |size| Card.sizes[size] }.sum] }
                      .to_h
    @story_points_per_member = assigned.merge!('Unassigned' => (@total_story_points - assigned.values.sum))

    # story points per size
    @story_points_per_size = @sprint.cards.group(:size).count
                                    .each_with_object({}) { |(k, v), h| h[k] = v * Card.sizes[k] }
                                    .except('o')

    # progress
    @sprint.cards.map(&:progress).sum / @sprint.cards.count
  end

  def trello
  end

  def pick
    trello_board_ids = current_user.boards.pluck(:trello_ext_id)
    @boards = trello_board_ids.map do |trello_board_id|
      ext_board = current_user.client.find(:boards, trello_board_id)
      {
        name: ext_board.name,
        trello_ext_id: trello_board_id,
        trello_url: ext_board.url
      }
    end
  end

  def create
    @sprint = Sprint.new(sprint_params)
    @sprint.user = current_user
    # board request using client
    ext_board = current_user.client.find(:boards, @sprint.trello_ext_id)

    if @sprint.save
      TrelloService.new(@sprint, ext_board).onboard
      redirect_to sprint_contribute_path(@sprint)
    else
      render :new, alert: 'Unable to create your sprint!'
    end
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def sprint_params
    params.require(:sprint).permit(
      :name,
      :trello_url,
      :user_id,
      :start_date,
      :end_date,
      :man_hours,
      :trello_ext_id
    )
  end
end
