class Task < ApplicationRecord
  validates :content, {presence: true}
  validates :time, {presence: true}
  validates :repeat, {presence: true}
  validates :date, {presence: true}

  def getTodayUnfinishedTasks (date)
    return Task.where(date:date).where(check:0)
  end    
end
