class Card < ApplicationRecord
  PROMPT = 'Add valid weight for progress data.'
  belongs_to :list
  belongs_to :member, optional: true

  validates :trello_ext_id, presence: true, uniqueness: true
  validates :size, presence: true
  enum size: %i[o xs s m l xl xxl]

  # statistics
  def story_points
    Card.sizes[size]
  end

  def progress
    size == 'o' ? PROMPT : (list.rank / list.sprint.lists_count.to_f).round(2)
  end

  # def weighted_progress
  #   progress.is_a?(String) ? PROMPT : progress * story_points
  # end
end
