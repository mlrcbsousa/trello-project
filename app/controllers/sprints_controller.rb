class SprintsController < ApplicationController
  def pick
    board_ids = current_user.boards.pluck(:trello_ext_id)
    client = current_user.create_client

    @boards = []
    # Thread.new do
      board_ids.each do |board_id|
        @boards << {
          name: client.find(:boards, board_id).name,
          trello_ext_id: board_id
        }
      end
    # end
    @boards
  end

  def new
    @sprint = Sprint.new
    @sprint.name = params[:name]
    @sprint.trello_ext_id = params[:trello_ext_id]
  end

  def create
  end
end
