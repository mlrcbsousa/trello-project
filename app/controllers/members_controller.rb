class MembersController < ApplicationController
  layout 'onboarding', only: %i[contribute labour onboard]

  def contribute
    @sprint = Sprint.find(params[:sprint_id])
    @members = @sprint.members
  end

  def labour
    @sprint = Sprint.find(params[:sprint_id])
    @sprint.members.pluck(:id).each do |id|
      Member.find(id).update(contributor: false) if params[:"contribute-#{id}"]
    end
    @members = @sprint.members.where(contributor: true)
  end

  def onboard
    @sprint = Sprint.find(params[:sprint_id])
    @sprint.members.pluck(:id).each do |id|
      Member.find(id).update(
        days_per_sprint: params[:"days_per_sprint-#{id}"].to_i,
        hours_per_day: params[:"hours_per_day-#{id}"].to_i
      )
    end
    # update man hours everytime you change labour hours
    @sprint.update_man_hours
    @members = @sprint.members
    redirect_to sprint_path(@sprint), notice: "Successfully created your sprint"
  end
end
