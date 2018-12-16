class Snapshot
  def initialize(sprint)
    @sprint = sprint
    @datetime_at_post = Time.now
    sprint_stats
    # member_stats
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
    available_hours_per_contributor
    conversion_per_size_per_contributor
    weighted_cards_per_size_per_contributor
    conversion_per_contributor
    weighted_cards_per_size_per_rank
    conversion_per_size_per_rank
    conversion_per_rank
    progress
    story_points_progress
    progress_conversion_per_rank
    progress_conversion
  ]

  MEMBER_STATS = %i[
    total_cards
    weighted_cards
    weighted_cards_count
    cards_per_size
    total_story_points
    progress
    story_points_progress
  ]

  def sprint_stats
    attrs = SPRINT_STATS.each_with_object({}) { |method, hash| hash[method] = @sprint.send method }
    attrs[:datetime_at_post] = @datetime_at_post
    @sprint.sprint_stats.create!(attrs)
  end

  def member_stats
    @sprint.members.each do |member|
      attrs = MEMBER_STATS.each_with_object({}) { |method, hash| hash[method] = member.send method }
      attrs[:datetime_at_post] = @datetime_at_post
      member.member_stats.create!(attrs)
    end
  end
end
