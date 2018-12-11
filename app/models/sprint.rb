class Sprint < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :lists, dependent: :destroy

  # Validations
  validates :trello_ext_id, presence: true, uniqueness: true

  validates :start_date, :end_date, presence: true
  # validates_timeliness gem
  # rails generate validates_timeliness:install
  validates_date :end_date, on_or_after: :start_date

  def total_days
    (end_date - start_date).to_i
  end

  def update_man_hours
    # TODO: what if we arent saving board information after member information
    update(man_hours: members.pluck(:total_hours).sum)
  end
end
