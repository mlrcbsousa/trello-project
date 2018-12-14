class Member < ApplicationRecord
  belongs_to :sprint
  has_many :cards

  validates :trello_ext_id, :hours_per_day, presence: true
  validates :trello_ext_id
  validates :full_name, format: { with: /\A[a-zA-Z ]+\z/, message: "only allows letters" }

  validates :hours_per_day, numericality: true, inclusion: { in: (0..24) }

  # days_per_sprint
  validate :days_per_sprint_less_than_total
  before_validation :days_per_sprint_default
  before_validation :set_total_hours

  # before_save :default_values
  # def default_values
  #   self.status ||= 'P' # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  # end

  def days_per_sprint_less_than_total
    errors.add(:member, "can't participate more days than the sprint total") if days_per_sprint > sprint.total_days
  end

  def days_per_sprint_default
    self.days_per_sprint = sprint.total_days if days_per_sprint.nil?
  end

  def set_total_hours
    self.total_hours = hours_per_day * days_per_sprint
  end

  # statistics
  def total_cards
    cards.count
  end

  def weighted_cards
    cards.where.not(size: :o)
  end

  def weighted_cards_count
    cards.where.not(size: :o).count
  end

  def cards_per_size
    cards.group(:size).count
  end

  def total_story_points
    cards.pluck(:size).map { |size| Card.sizes[size] }.sum
  end

  def progress
    (weighted_cards.map(&:progress).sum / weighted_cards_count).round(2)
  end

  def story_points_progress
    (progress * total_story_points).round(2)
  end
end
