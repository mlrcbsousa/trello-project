class Member < ApplicationRecord
  belongs_to :sprint
  has_many :cards

  validates :contributor, :trello_ext_id, :hours_per_day, presence: true
  validates :trello_ext_id, uniqueness: true
  validates :full_name # , format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }

  validates :hours_per_day, numericality: true, inclusion: { in: (0..24) }
  validates :total_hours, numericality: true

  # days_per_sprint
  validate :days_per_sprint_less_than_total
  before_validation :days_per_sprint_default
  after_before_validation :set_total_hours

  def days_per_sprint_less_than_total
    errors.add(:member, "Can't participate more days than the sprint total") if days_per_sprint <= sprint.total_days
  end

  def days_per_sprint_default
    self.days_per_sprint = sprint.total_days if days_per_sprint.nil?
  end

  def set_total_hours
    self.total_hours = hours_per_day * days_per_sprint
  end
end
