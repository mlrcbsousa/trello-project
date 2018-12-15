class List < ApplicationRecord
  belongs_to :sprint
  has_many :cards, dependent: :destroy

  validates :trello_ext_id, presence: true

  def weighted_cards
    cards.where.not(size: :o)
  end

  def weighted_cards_per_size
    weighted_cards.group(:size).count
  end
end
