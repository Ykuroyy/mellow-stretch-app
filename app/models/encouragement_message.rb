class EncouragementMessage < ApplicationRecord
  validates :message, presence: true
  validates :category, presence: true, inclusion: { in: %w[stretch breathing general] }
  
  scope :for_category, ->(category) { where(category: category) }
  scope :general, -> { where(category: 'general') }
  
  def self.random_for_category(category)
    for_category(category).order('RANDOM()').first || general.order('RANDOM()').first
  end
end
