class Board < ApplicationRecord
  belongs_to :user
  validates :trello_ext_id, presence: true
end
