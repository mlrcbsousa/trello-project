class SprintsController < ApplicationController
  before_action :set_sprint, only: %i[show destroy]
  before_action :destroy_lists, only: :destroy
  layout 'onboarding', only: :new

  def index
    @sprints = current_user.sprints
  end

  def new
    @name = params[:name]
    @trello_ext_id = params[:trello_ext_id]
    @trello_url = params[:trello_url]
    @sprint = Sprint.new
  end

  def show; end

  def create
    @sprint = Sprint.new(sprint_params)
    @sprint.user = current_user
    # board request using client
    ext_board = current_user.client.find(:boards, @sprint.trello_ext_id)

    if @sprint.save
      # service class
      Onboard.new(@sprint, ext_board)
      redirect_to new_conversion_path(@sprint)
    else
      render :new, alert: 'Unable to create your sprint!'
    end
  end

  def destroy
    @sprint.destroy
    respond_to do |format|
      format.html { redirect_to sprints_path, notice: 'Sprint was successfully deleted.' }
      format.js
    end
  end

  private

  def destroy_lists
    @sprint.lists.destroy_all
  end

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def sprint_params
    params.require(:sprint).permit(
      :name,
      :trello_url,
      :user_id,
      :start_date,
      :end_date,
      :man_hours,
      :trello_ext_id
    )
  end
end
