class Card < ApplicationRecord
  belongs_to :list
  belongs_to :member, optional: true

  validates :trello_ext_id, presence: true, uniqueness: true
  validates :size, presence: true
  enum size: %i[o xs s m l xl xxl]
end
