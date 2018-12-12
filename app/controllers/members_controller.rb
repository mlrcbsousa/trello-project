class MembersController < ApplicationController
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
      member = Member.find(id).update(
        days_per_sprint: params[:"days_per_sprint-#{id}"],
        hours_per_day: params[:"hours_per_day-#{id}"]
      )
      member.set_total_hours
    end
    @members = @sprint.members
    @sprint.update_man_hours
    redirect_to sprint_path(@sprint), notice: "Successfully created your sprint"
  end
end
