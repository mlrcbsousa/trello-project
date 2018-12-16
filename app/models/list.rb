class List < ApplicationRecord
  PROMPT = 'List is a backlog or otherwise unranked.'
  belongs_to :sprint
  has_many :cards, dependent: :destroy

  validates :trello_ext_id, presence: true

  def weighted_cards
    cards.where.not(size: :o)
  end

  def weighted_cards_per_size
    weighted_cards.group(:size).count
  end

  def progress_rank
    rank.zero? ? PROMPT : (rank / sprint.total_ranks.to_f).round(2)
  end
end
