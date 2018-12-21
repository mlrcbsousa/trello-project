"<%= favicon_link_tag asset_path('favicon.ico'), :rel => 'icon', :type =>  'image/png' %>"
  <%= #link_to update_sprint_path(@sprint), method: :post do %>
            <!-- <i class="fas fa-sync-alt"></i> -->
          <% #end %>
# sprint
updateBoard

# members
memberJoinedTrello
makeObserverOfBoard
makeNormalMemberOfBoard
makeAdminOfBoard
addAdminToBoard
addMemberToBoard
updateMember
removeAdminFromBoard
removeMemberFromBoard

# lists
createList
moveListFromBoard
moveListToBoard
updateList

# cards
updateCard
addMemberToCard
copyCard
createCard
deleteCard
moveCardFromBoard
moveCardToBoard
removeMemberFromCard

<%= favicon_link_tag asset_path('favicon.ico'), :rel => 'icon', :type =>  'image/png' %>
