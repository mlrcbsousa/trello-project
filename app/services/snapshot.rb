class Snapshot
  # @sprint, @description, @datetime_at_post
  def initialize(attrs = { description: 'general', datetime_at_post: Time.now })
    attrs.each { |k, v| instance_variable_set :"@#{k}", v }
    sprint_stats
    member_stats
  end

  SPRINT_STATS = %i[
    available_man_hours
    total_contributors
    total_days
    total_days_from_start
    total_days_to_end
    total_ranks
    total_cards
    cards_per_size
    total_weighted_cards
    weighted_cards_per_size
    weighted_cards_per_rank
    total_story_points
    weighted_cards_per_contributor
    story_points_per_contributor
    story_points_per_size
    conversion_per_size
    total_conversion
    conversion_per_size_per_contributor
    conversion_per_size_per_contributor_ck
    weighted_cards_per_size_per_contributor
    weighted_cards_per_size_per_contributor_ck
    conversion_per_contributor
    available_hours_per_contributor
    merged_conversion_per_contributor
    weighted_cards_per_size_per_rank
    weighted_cards_per_size_per_rank_ck
    conversion_per_size_per_rank
    conversion_per_size_per_rank_ck
    conversion_per_rank
    progress_conversion_per_rank
    merged_conversion_per_rank
    progress_conversion
    progress
    story_points_progress
  ]

  MEMBER_STATS = %i[
    available_hours
    weighted_cards_count
    weighted_cards_per_size
    weighted_cards_per_rank
    weighted_cards_per_size_per_rank
    weighted_cards_per_size_per_rank_ck
    conversion_per_size_per_rank
    conversion_per_size_per_rank_ck
    conversion_per_size
    conversion_per_rank
    total_conversion
    total_story_points
    progress
    story_points_progress
  ]

  def sprint_stats
    attrs = SPRINT_STATS.each_with_object({}) { |method, hash| hash[method] = @sprint.send method }
    attrs[:datetime_at_post] = @datetime_at_post
    attrs[:description] = @description
    @sprint.sprint_stats.create!(attrs)
  end

  def member_stats
    @sprint.contributors.each do |member|
      attrs = MEMBER_STATS.each_with_object({}) { |method, hash| hash[method] = member.send method }
      attrs[:datetime_at_post] = @datetime_at_post
      attrs[:description] = @description
      member.member_stats.create!(attrs)
    end
  end
end
