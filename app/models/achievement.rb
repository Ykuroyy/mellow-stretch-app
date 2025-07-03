class Achievement < ApplicationRecord
  validates :date, presence: true
  validates :activity_type, presence: true, inclusion: { in: %w[stretch breathing] }
  validates :completed, inclusion: { in: [true, false] }
  
  scope :for_date, ->(date) { where(date: date) }
  scope :stretches, -> { where(activity_type: 'stretch') }
  scope :breathing_exercises, -> { where(activity_type: 'breathing') }
  scope :completed, -> { where(completed: true) }
  
  def self.mark_completed(date, activity_type)
    find_or_create_by(date: date, activity_type: activity_type) do |achievement|
      achievement.completed = true
    end
  end
end
