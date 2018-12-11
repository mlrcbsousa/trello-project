class SprintsController < ApplicationController
  def new
    board_ids = current_user.boards.pluck(:trello_ext_id)
    client = current_user.create_client

    @boards = []
    # Thread.new do
      board_ids.each do |board_id|
        @boards << {
          name: client.find(:boards, board_id).name,
          board_id: board_id
        }
      end
    # end
    @boards
  end
end
