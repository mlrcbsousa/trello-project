class OnboardController < ApplicationController
  layout 'onboarding', only: %i[pick contribute schedule complete]
  before_action :set_sprint, except: :pick

  def pick
    trello_board_ids = current_user.boards.pluck(:trello_ext_id)
                                   .delete_if { |id| current_user.sprints.pluck(:trello_ext_id).include?(id) }
    @boards = trello_board_ids.map do |trello_board_id|
      ext_board = current_user.client.find(:boards, trello_board_id)
      {
        name: ext_board.name,
        trello_ext_id: trello_board_id,
        trello_url: ext_board.url
      }
    end
  end

  def contribute
    @members = @sprint.members
  end

  def schedule
    @sprint.members.pluck(:id).each do |id|
      Member.find(id).update(contributor: false) if params[:"contribute-#{id}"]
    end
    @members = @sprint.members.where(contributor: true)
  end

  def complete
    @sprint.members.pluck(:id).each do |id|
      Member.find(id).update(
        days_per_sprint: params[:"days_per_sprint-#{id}"].to_i,
        hours_per_day: params[:"hours_per_day-#{id}"].to_i
      )
    end
    # update man hours everytime you change labour hours
    @sprint.update_man_hours
    redirect_to sprint_path(@sprint), notice: "Successfully created your sprint"
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end
end
