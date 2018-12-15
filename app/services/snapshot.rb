class Snapshot
  def initialize(sprint)
    @sprint = sprint
    @timestamp = Time.now
    sprint_stats
    member_stats
  end

  # TODO: persist all stats at current time
  SPRINT_STATS = %i[
    total_story_points
    total_days_from_start
    total_days_to_end
    total_days
    contributors
    lists_count
    total_cards
    weighted_cards
    weighted_cards_count
    cards_per_size
    weighted_cards_per_size
    cards_per_rank
    total_story_points
    cards_per_contributor
    story_points_per_contributor
    story_points_per_size
    progress
    story_points_progress
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
    attrs[:timestamp] = @timestamp
    @sprint.sprint_stats.create!(attrs)
  end

  def member_stats
    @sprint.members.each do |member|
      attrs = MEMBER_STATS.each_with_object({}) { |method, hash| hash[method] = member.send method }
      attrs[:timestamp] = @timestamp
      member.member_stats.create!(attrs)
    end
  end
end
