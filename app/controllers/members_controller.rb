class MembersController < ApplicationController
  before_action :set_sprint, only: %i[index show]

  def index
    @members = @sprint.members
  end

  def show
    @member = Member.find(params[:id])
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:sprint_id])
  end
end
