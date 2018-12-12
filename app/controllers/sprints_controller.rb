class SprintsController < ApplicationController
  def pick
    board_ids = current_user.boards.pluck(:trello_ext_id)

    @boards = board_ids.map do |board_id|
      {
        name: current_user.client.find(:boards, board_id).name,
        trello_ext_id: board_id
      }
    end
  end

  def new
    @name = params[:name]
    @trello_ext_id = params[:trello_ext_id]
    @sprint = Sprint.new
  end

  def create
    @sprint = Sprint.new(sprint_params)
    @sprint.user = current_user

    # board request using client
    ext_board = current_user.client.find(:boards, @sprint.trello_ext_id)

    @sprint.trello_url = ext_board.url
    @sprint.save

    # create members
    ext_board.members.each do |member|
      Member.create!(
        trello_ext_id: member.id,
        sprint: @sprint,
        full_name: member.full_name,
        trello_avatar_url: 'placeholder'
      )
    end

    # # create lists
    # ext_board.lists.each do |list|
    #   List.create(
    #     trello_ext_id: list.id,
    #     sprint: @sprint
    #   )
    # end

    # # create cards
    # ext_board.cards.each do |card|
    #   Card.create(
    #     list: List.find_by(trello_ext_id: card.list.id),
    #     trello_ext_id: card.id,
    #     size: card.name.split('|')[-1].downcase.strip,
    #     member: Member.find_by(trello_ext_id: card.member_ids.first)
    #   )
    # end

    # redirect to members#config
    redirect_to sprint_contribute_path(@sprint)
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
