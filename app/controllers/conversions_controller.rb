class ConversionsController < ApplicationController
  before_action :set_sprint, only: %i[new create]
  before_action :set_sprint_id, only: %i[edit update]
  before_action :set_conversion, only: %i[edit update]
  layout 'onboarding', only: :new
  layout 'sprint_edits', only: :edit

  def new
    @conversion = Conversion.new
  end

  def create
    @conversion = Conversion.new(conversion_params)
    @conversion.sprint = @sprint
    if @conversion.save
      redirect_to contribute_path(@sprint)
    else
      render :new, alert: 'Invalid conversion!'
    end
  end

  def edit; end

  def update
    @conversion.update(conversion_params)
    if @conversion.save
      redirect_to sprints_path, notice: 'Conversion was successfully updated.'
    else
      render :edit, alert: 'Unable to update conversion.'
    end
  end

  private

  def set_sprint_id
    @sprint = Sprint.find(params[:sprint_id])
  end

  def set_conversion
    @conversion = Conversion.find(params[:id])
  end

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def conversion_params
    params.require(:conversion).permit(:xs, :s, :m, :l, :xl, :xxl)
  end
end
