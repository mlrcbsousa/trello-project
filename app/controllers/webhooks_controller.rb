# app/controllers/webhooks_controller.rb
class WebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token

  EVENTS = {
    sprint: ["updateBoard"],
    members: %w[
      memberJoinedTrello
      makeObserverOfBoard
      makeNormalMemberOfBoard
      makeAdminOfBoard
      addAdminToBoard
      addMemberToBoard
      updateMember
      removeAdminFromBoard
      removeMemberFromBoard
    ],
    lists: %w[
      createList
      moveListFromBoard
      moveListToBoard
      updateList
    ],
    cards: %w[
      updateCard
      addMemberToCard
      copyCard
      createCard
      deleteCard
      moveCardFromBoard
      moveCardToBoard
      removeMemberFromCard
    ]
  }

  def complete
    return head :ok
  end

  def receive
    sprints = Sprint.where(trello_ext_id: params[:model][:id])
    event = params[:event][:type]
    EVENTS.each { |model, events| sprints.each { |sprint| trello(sprint, model) } if events.include?(event) }
  end

  private

  def trello(sprint, model)
    TrelloAPI.new(sprint: sprint, type: :update, model: model)
  end
end

# params[:event].keys
# [:id, :idMemberCreator, :data, :type, :date, :limits, :display, :memberCreator]

# params[:model]
# [:id, :name, :desc, :descData, :closed, :idOrganization, :pinned, :url, :shortUrl, :prefs, :labelNames]

# params[:webhook]
# [:model, :event]

# if event == "updateBoard"
#   sprints.each { |sprint| trello(sprint, :sprint) }
# elsif MEMBERS.include?(event)
#   sprints.each { |sprint| trello(sprint, :members) }
# elsif LISTS.include?(event)
#   sprints.each { |sprint| trello(sprint, :lists) }
# elsif CARDS.include?(event)
#   sprints.each { |sprint| trello(sprint, :cards) }
# end
# Rails.logger.info "================>>>>>>>>>>>>>>> #{params[:event][:type].inspect}"
