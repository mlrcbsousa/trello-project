class Sprint < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :lists, dependent: :destroy

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
    # TODO: what if we arent saving board information after member information
    update(man_hours: members.pluck(:total_hours).sum)
  end

  def create_webhook
    webhook = Trello::Webhook.new(
      description: "Sprint webhook",
      id_model: trello_ext_id,
      # BASE_URL is your website's url. Use ngrok in dev.
      callback_url: "#{ENV['BASE_URL']}/trello_webhooks"
    )
    webhook.save
  end
end
