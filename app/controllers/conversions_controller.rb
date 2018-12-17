class ConversionsController < ApplicationController
  before_action :set_sprint
  layout 'onboarding', only: :new

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

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def conversion_params
    params.require(:conversion).permit(:xs, :s, :m, :l, :xl, :xxl)
  end
end
