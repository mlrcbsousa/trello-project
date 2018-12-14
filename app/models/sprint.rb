class Sprint < ApplicationRecord
  require 'trello'
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :cards, through: :lists, dependent: :destroy

  # Validations
  validates :start_date, :end_date, :trello_ext_id, :name, presence: true
  # validates_timeliness gem
  # rails generate validates_timeliness:install
  validates_date :end_date, on_or_after: :start_date
  # after_create :create_webhook

  def total_days
    (end_date - start_date).to_i
  end

  def update_man_hours
    total_hours = members.where(contributor: true).pluck(:total_hours)
    update(man_hours: total_hours.sum)
  end

  def webhook
    @webhook ||= Trello::Webhook.new(
      description: "Sprint webhook",
      id_model: trello_ext_id,
      # BASE_URL is your website's url. Use ngrok in dev.
      callback_url: "#{ENV['BASE_URL']}trello_webhooks"
    )
    @webhook.save
  end

  # statistics
  def contributors
    members.where(contributor: true)
  end

  def lists_count
    lists.count
  end

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

  def weighted_cards_per_size
    weighted_cards.group(:size).count
  end

  def total_story_points
    cards.pluck(:size).map { |size| Card.sizes[size] }.sum
  end

  # only weighted cards, only contributing members
  def cards_per_contributor
    assigned = weighted_cards.group(:member).count
                             .select { |key, _value| key.contributor if key.respond_to?(:contributor) }
                             .transform_keys(&:full_name)
    assigned.merge!('Unassigned' => (weighted_cards_count - assigned.values.sum))
  end

  # only contributing members
  def story_points_per_contributor
    assigned = contributors.map { |member| [member.full_name, member.total_story_points] }.to_h
    assigned.merge!('Unassigned' => (total_story_points - assigned.values.sum))
  end

  def story_points_per_size
    cards.group(:size).count
         .each_with_object({}) { |(key, value), hash| hash[key] = value * Card.sizes[key] }
         .except('o')
  end

  def progress
    (weighted_cards.map(&:progress).sum / weighted_cards_count).round(2)
  end

  def story_points_progress
    (progress * total_story_points).round(2)
  end
end
