class Event < ApplicationRecord
  validates :content, presence: {message: "イベント名を入力してください"}
  validates :repeat, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :place, presence: true

  def getTodayEvent(today, user_id)
    events = Event.where(date:today).where(user_id:user_id)
    event_list=""
    events.each do |event|
      event_list += "#{event.pluck(:content)}、"
    end
    return event_list
  end
end
