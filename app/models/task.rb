class Task < ApplicationRecord
  validates :content, {presence: true}
  validates :time, {presence: true}
  validates :repeat, {presence: true}
  validates :date, {presence: true}
end
