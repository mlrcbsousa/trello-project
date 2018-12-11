class List < ApplicationRecord
  belongs_to :sprint
  has_many :cards

  validates :trello_ext_id, presence: true, uniqueness: true
end
