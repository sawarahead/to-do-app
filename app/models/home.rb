class Home < ApplicationRecord

  validates :name, presence: true
  validates :password, presence: true

end
