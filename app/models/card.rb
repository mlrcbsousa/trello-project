class Card < ApplicationRecord
  belongs_to :list
  belongs_to :member
  belongs_to :sprint, through: :lists

  validates :trello_ext_id, presence: true, uniqueness: true
  validates :size, presence: true, uniqueness: true
  enum size: %i[xs s m l xl xxl]
end
