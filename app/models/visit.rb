class Visit < ApplicationRecord
  belongs_to :user, optional: true

  validates :page_path, presence: true
  validates :visit_count, numericality: { greater_than_or_equal_to: 0 }

  scope :today, -> { where('created_at >= ?', Time.current.beginning_of_day) }
  scope :for_user, ->(user) { where(user_id: user.id) }

  # Record a visit for a given page and user (optional)
  def self.record_visit(page_path, user = nil)
    transaction do
      visit = find_or_initialize_by(page_path: page_path, user_id: user&.id)
      visit.visit_count ||= 0
      visit.visit_count += 1
      visit.last_visited_at = Time.current
      visit.save!
      visit
    end
  rescue => e
    Rails.logger.error "Error recording visit: #{e.message}"
    nil
  end

  def time_since_last_visit
    return "Never visited" unless last_visited_at

    time_diff = Time.current - last_visited_at
    case time_diff
    when 0..59
      "#{time_diff.to_i} seconds ago"
    when 60..3599
      minutes = (time_diff / 60).to_i
      "#{minutes} #{'minute'.pluralize(minutes)} ago"
    when 3600..86399
      hours = (time_diff / 3600).to_i
      "#{hours} #{'hour'.pluralize(hours)} ago"
    else
      days = (time_diff / 86400).to_i
      "#{days} #{'day'.pluralize(days)} ago"
    end
  end

  def update_visit
    self.last_visited_at = Time.current
    self.visit_count ||= 0
    self.visit_count += 1
    save!
  end

  def reset_visit_count
    self.visit_count = 0
    save!
  end

  def self.total_visits_for_user(user)
    for_user(user).sum(:visit_count)
  end

  def self.page_visits_today_for_user(user)
    today.for_user(user).sum(:visit_count)
  end

  def page_visits
    user ? self.class.page_visits_today_for_user(user) : 0
  end

  def total_visits
    user ? self.class.total_visits_for_user(user) : 0
  end
end
