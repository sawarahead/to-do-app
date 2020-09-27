class Event < ApplicationRecord
  validates :content, presence: {message: "イベント名を入力してください"}
  validates :repeat, presence: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :place, presence: true
end
