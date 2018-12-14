class List < ApplicationRecord
  belongs_to :sprint
  has_many :cards, dependent: :destroy

  validates :trello_ext_id, presence: true
end
