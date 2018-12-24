class Webhook < ApplicationRecord
  belongs_to :user
  has_many :sprints
end
