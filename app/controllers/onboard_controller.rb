class OnboardController < ApplicationController
  layout 'onboarding'
  before_action :set_sprint, except: :pick

  def pick
    sprints = current_user.sprints.pluck(:trello_ext_id)
    @boards = current_user.boards.where.not(trello_ext_id: sprints)
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
    Snapshot.new(sprint: @sprint, description: 'first after create')
    redirect_to sprint_path(@sprint), notice: "Successfully created your sprint"
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end
end
