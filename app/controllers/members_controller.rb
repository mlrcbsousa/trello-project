class MembersController < ApplicationController
  def config
    sprint = Sprint.find(params[:id])
    @members = sprint.members
    # contributor:,
  end

  def labour
    sprint = Sprint.find(params[:id])
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
