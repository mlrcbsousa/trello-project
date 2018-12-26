class Sprint < ApplicationRecord
  require 'trello'
  belongs_to :user
  belongs_to :webhook, optional: true
  has_many :members, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :cards, through: :lists, dependent: :destroy
  has_many :sprint_stats, dependent: :destroy
  has_many :member_stats, through: :members, dependent: :destroy
  has_one :conversion, dependent: :destroy

  # Validations
  validates :start_date, :end_date, :trello_ext_id, :name, presence: true
  # validates_timeliness gem
  # rails generate validates_timeliness:install
  validates_date :end_date, on_or_after: :start_date

  # Callbacks
  after_destroy :delete_webhook

  # --------- Trello webhook
  # Must include the fact that only one webhook will be created per sprint
  # even if more then one user sets up the same board as a sprint on the app
  def delete_webhook
    # find the next sprint using that webhook, and recreate webhook in that sprint.user's name
    # delete webhook if no other sprint is using that webhook
    if webhook
      webhook.sprints.count > 1 ? webhook.sprints.where.not(user: user)[0].post_webhook : webhook.destroy
    end
    user.delete_wh_by_sprint(self)
  end

  def create_webhook
    post_webhook
    # Rails.logger.info "=M=A=D=A=F=U=K=I=N=====W=E=B=H=O=O=K======>>>>>>>>>>>>>> #{response.inspect}"
    update(webhook: Webhook.create!(ext_board_id: trello_ext_id))
  end

  # sends post request for creation of webhook on trello
  def post_webhook
    HTTParty.post(
      "https://api.trello.com/1/tokens/#{user.token}/webhooks/?key=#{ENV['TRELLO_KEY']}",
      query: {
        description: "Sprint webhook user#{user.id}",
        callbackURL: "#{ENV['BASE_URL']}webhooks",
        idModel: trello_ext_id
      },
      headers: { "Content-Type" => "application/json" }
    )
  end

  # ----------
  # helper methods
  def weighted_cards
    cards.where.not(size: :o)
  end

  def contributors
    members.where(contributor: true)
  end

  def ranks
    lists.where.not(rank: 0)
  end

  # call this method after changing any member child schedule
  def update_available_man_hours
    update(available_man_hours: contributors.pluck(:available_hours).sum)
  end

  # STATISTICS
  # integer
  def total_contributors
    contributors.count
  end

  # integer
  def total_days
    (end_date - start_date).to_i
  end

  # integer
  def total_days_from_start
    (Date.today - start_date).to_i
  end

  # integer
  def total_days_to_end
    (end_date - Date.today).to_i
  end

  # integer
  def total_ranks
    lists.where.not(rank: 0).count
  end

  # ------ METRICS ON CARDS ------
  # integer
  def total_cards
    cards.count
  end

  # integer
  def total_cards_done_or_after_done
    ranks[ranks.count - 2].cards.count + ranks.last.cards.count
  end

  # integer
  def total_cards_in_backlog
    ranks[0].cards.count
  end

  # integer
  def total_cards_in_progress
    total_cards - (total_cards_done_or_after_done + total_cards_in_backlog)
  end

  # hash
  def cards_per_size
    cards.group(:size).count
  end

  # integer
  def total_weighted_cards
    cards.where.not(size: :o).count
  end

  # hash
  def weighted_cards_per_size
    weighted_cards.group(:size).count
  end

  # hash
  def weighted_cards_per_rank
    weighted_cards.group(:name).count
  end

  # integer
  def total_story_points
    cards.pluck(:size).map { |size| Card.sizes[size] }.sum
  end

  # only weighted cards, only contributing members
  # hash
  def weighted_cards_per_contributor
    @assigned = weighted_cards.group(:member).count
                              .select { |key, _value| key.contributor if key.respond_to?(:contributor) }
                              .transform_keys(&:full_name)
    @assigned.merge!('Unassigned' => (total_weighted_cards - @assigned.values.sum))
  end

  # only contributing members
  # hash
  def story_points_per_contributor
    assigned = contributors.map { |c| [c.full_name, c.total_story_points] }.to_h
    assigned.merge!('Unassigned' => (total_story_points - assigned.values.sum))
  end

  # hash
  def story_points_per_size
    cards.group(:size).count
         .each_with_object({}) { |(key, value), hash| hash[key] = value * Card.sizes[key] }
         .except('o')
  end

  # hash
  def conversion_per_size
    weighted_cards_per_size.each_with_object({}) { |(k, v), h| h[k] = v * conversion.send(k) }
  end

  # integer
  def total_conversion
    conversion_per_size.values.sum
  end

  # hash of hashes
  def conversion_per_size_per_contributor
    weighted_cards_per_size_per_contributor.transform_values do |value|
      value.each_with_object({}) { |(k, v), h| h[k] = v * conversion.send(k) }
    end
  end

  # for Chartkick
  def conversion_per_size_per_contributor_ck
    conversion_per_size_per_contributor.map { |k, v| { name: k, data: v } }
  end

  # hash of hashes
  def weighted_cards_per_size_per_contributor
    contributors.each_with_object({}) do |contributor, hash|
      hash[contributor.full_name] = contributor.weighted_cards_per_size
    end
  end

  # for Chartkick
  def weighted_cards_per_size_per_contributor_ck
    weighted_cards_per_size_per_contributor.map { |k, v| { name: k, data: v } }
  end

  # ----------------
  # hash
  def conversion_per_contributor
    conversion_per_size_per_contributor.transform_values(&:values).transform_values(&:sum)
  end

  # hash
  def available_hours_per_contributor
    contributors.map { |c| [c.full_name, c.available_hours] }.to_h
  end

  # merge for Chartkick
  def merged_conversion_per_contributor
    [
      { name: 'Allocated', data: conversion_per_contributor },
      { name: 'Available', data: available_hours_per_contributor }
    ]
  end
  # ----------------

  # hash of hashes
  def weighted_cards_per_size_per_rank
    ranks.each_with_object({}) { |rank, hash| hash[rank.name] = rank.weighted_cards_per_size }
  end

  # for Chartkick
  def weighted_cards_per_size_per_rank_ck
    weighted_cards_per_size_per_rank.map { |k, v| { name: k, data: v } }
  end

  # hash of hashes
  def conversion_per_size_per_rank
    weighted_cards_per_size_per_rank.transform_values do |value|
      value.each_with_object({}) { |(k, v), h| h[k] = v * conversion.send(k) }
    end
  end

  # for Chartkick
  def conversion_per_size_per_rank_ck
    conversion_per_size_per_rank.map { |k, v| { name: k, data: v } }
  end

  # ---------------
  # hash of hashes
  def conversion_per_rank
    conversion_per_size_per_rank.transform_values(&:values).transform_values(&:sum)
    # conversion_per_size_per_rank.each_with_object({}) { |(k, v), h| h[k] = v.values.sum }
  end

  def progress_conversion_per_rank
    conversion_per_rank.each_with_object({}) do |(k, v), h|
      h[k] = (v * lists.find_by(name: k).progress_rank).to_i
    end
  end

  # merge for Chartkick
  def merged_conversion_per_rank
    [
      { name: 'Work', data: conversion_per_rank },
      { name: 'Progress', data: progress_conversion_per_rank }
    ]
  end
  # ----------------

  def progress_conversion
    progress_conversion_per_rank.values.sum.to_i
  end

  # decimal (percentage)
  def progress
    progress_data = weighted_cards.map(&:progress).delete_if { |item| item.is_a?(String) }
    total_weighted_cards.zero? ? 0 : (progress_data.sum / total_weighted_cards).round(2)
  end

  # integer
  def story_points_progress
    (progress * total_story_points).to_i
  end

  def stppot
    sprint_stats.map { |s| [s.created_at, (s.total_story_points - s.story_points_progress)] }.to_h
  end

  # not usable by chartkick for some reason
  def stppot_merge_x
    s = sprint_stats.last
    [
      { name: 'Actual', data: stppot },
      {
        name: 'Projection',
        data: {
          s.created_at => (s.total_story_points - s.story_points_progress),
          end_date => 0
        }
      }
    ]
  end

  # actual burndown chart patch used
  def stppot_merge
    s = sprint_stats.last
    stppot.merge(
      s.created_at => (s.total_story_points - s.story_points_progress),
      end_date => 0
    )
  end
end
