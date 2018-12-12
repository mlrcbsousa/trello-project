class MembersController < ApplicationController
  def contribute
    @sprint = Sprint.find(params[:sprint_id])
    @members = @sprint.members
    raise
    # contributor:,
  end

  def labour
    raise
    sprint = Sprint.find(params[:sprint_id])
    @members = sprint.members
    # days_per_sprint:,
    # hours_per_day:,
  end

  def onboard
    # update.params[]
    # @sprint.update_man_hours
  end

  private

  # def onboarding_params

  # end
end
