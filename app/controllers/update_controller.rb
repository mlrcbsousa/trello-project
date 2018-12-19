class UpdateController < ApplicationController
  before_action :set_sprint

  def sprint
    trello(:sprint)
  end

  def members
    trello(:members)
  end

  def lists
    trello(:lists)
  end

  def cards
    trello(:cards)
  end

  private

  def trello(model)
    TrelloAPI.new(sprint: @sprint, type: :update, model: model)
    redirect_to sprint_path(@sprint)
  end

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end
end
