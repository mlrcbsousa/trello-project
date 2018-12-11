class MembersController < ApplicationController
  def config
    sprint = Sprint.find(params[:id])
    @members = sprint.members
  end

  def onboard
    # update.params[]
  end

  private

  # def onboarding_params

  # end
end
