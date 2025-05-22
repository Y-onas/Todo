class Todo < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :completed, inclusion: { in: [true, false] }

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  def toggle_completed
    update(completed: !completed)
  end
end
