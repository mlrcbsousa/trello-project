class MembersController < ApplicationController
  before_action :set_sprint, only: %i[index edit update]
  before_action :set_sprint_id, only: %i[contribute contribute_patch]
  before_action :set_member, only: %i[edit update]
  layout 'onboarding'

  def index
    @members = @sprint.members.where(contributor: true)
  end

  def edit; end

  def contribute
    @members = @sprint.members.each { |member| member.update(contributor: true) }
  end

  def contribute_patch
    @sprint.members.pluck(:id).each do |id|
      Member.find(id).update(contributor: false) if params[:"contribute-#{id}"]
    end
    redirect_to sprint_members_path(@sprint), notice: "edit your updated member's schedule"
  end

  def schedule
    @members = @sprint.members.where(contributor: true)
  end

  def update
    @member.update(member_params)
    if @member.save
      @sprint.update_available_man_hours
      Snapshot.new(sprint: @sprint, description: 'member edit')
      redirect_to sprints_path, notice: 'member was successfully updated.'
    else
      render :edit, alert: 'Unable to update member.'
    end
  end

  private

  def member_params
    params.require(:member).permit(:contributor, :hours_per_day, :days_per_sprint, :sprint_id)
  end

  def set_member
    @member = Member.find(params[:id])
  end

  def set_sprint_id
    @sprint = Sprint.find(params[:id])
  end

  def set_sprint
    @sprint = Sprint.find(params[:sprint_id])
  end
end
