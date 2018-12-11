class SprintsController < ApplicationController
  def pick
    board_ids = current_user.boards.pluck(:trello_ext_id)
    client = current_user.create_client

    # Thread.new do
    @boards = board_ids.map do |board_id|
      {
        name: client.find(:boards, board_id).name,
        trello_ext_id: board_id
      }
    end
    # end
  end

  def new
    @name = params[:name]
    @trello_ext_id = params[:trello_ext_id]
    @sprint = Sprint.new
  end

  def create
    @sprint = Sprint.new(sprint_params)
    @sprint.user = current_user

    client = current_user.create_client
    ext_board = client.find(:boards, @sprint.trello_ext_id)
    raise

    # # create members
    # ext_board.members.each do |member|
    #   Member.create(
    #     trello_ext_id:,
    #     sprint: @sprint,
    #     full_name:,
    #     trello_avatar_url:,
    #     # contributor:,
    #     # days_per_sprint:,
    #     # hours_per_day:,
    #     # member.sprint.update_man_hours
    #   )
    # end

    # # create lists
    # ext_board.lists.each do |list|
    #   List.create(
    #     trello_ext_id:,
    #     sprint: @sprint,
    #   )
    # end

    # # create cards
    # ext_board.cards.each do |card|
    #   Card.create(
    #     list: List.find,_by(),
    #     trello_ext_id:,
    #     size:, #regex
    #     member: Member.find_by(trello_ext_id: ext_card.members.first.id)
    #   )
    # end

    # redirect to member details edit page
    # redirect onboard_members
  end

  private

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
