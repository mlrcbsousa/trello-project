class Member < ApplicationRecord
  belongs_to :sprint
  has_many :cards
  has_many :member_stats

  # Validations
  validates :trello_ext_id, :hours_per_day, presence: true
  validates :full_name, format: { with: /\A[a-zA-Z ]+\z/, message: "only allows letters" }
  validates :hours_per_day, numericality: true, inclusion: { in: (0..24) }
  # days_per_sprint
  validate :days_per_sprint_less_than_total
  before_validation :days_per_sprint_default
  before_validation :set_available_hours

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

  def set_available_hours
    self.available_hours = hours_per_day * days_per_sprint
  end

  def weighted_cards
    cards.where.not(size: :o)
  end

  # STATISTICS
  # integer
  def total_cards
    cards.count
  end

  # integer
  def weighted_cards_count
    cards.where.not(size: :o).count
  end

  # hash
  def weighted_cards_per_size
    weighted_cards.group(:size).count
  end

  # hash
  def conversion_per_size
  end

  # hash
  def conversion_per_rank
  end

  # integer
  def total_story_points
    cards.pluck(:size).map { |size| Card.sizes[size] }.sum
  end

  # float
  def progress
    (weighted_cards.map(&:progress).sum / weighted_cards_count).round(2)
  end

  # integer
  def story_points_progress
    (progress * total_story_points).round(2)
  end
end
