# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  layout 'home', only: [:home]

  def home
  end


end
