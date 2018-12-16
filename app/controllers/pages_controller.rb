# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'pages'

  def home; end

  def knowledge; end

  def pricing; end

  def about; end

  def testing; end
end
