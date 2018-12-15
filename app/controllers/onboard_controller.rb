class OnboardController < ApplicationController
  layout 'onboarding' # , only: %i[pick contribute schedule complete]
  before_action :set_sprint, except: :pick

  def pick
    @boards = current_user.boards.where.not(trello_ext_id: current_user.sprints.trello_ext_id)
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
    @sprint.update_available_man_hours
    redirect_to sprint_path(@sprint), notice: "Successfully created your sprint"
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end
end
