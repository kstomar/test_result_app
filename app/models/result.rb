class Result < ApplicationRecord
  validates :subject, :timestamp, :marks, presence: true
  scope :today, -> { where("DATE(timestamp) = ?", Date.today)}
end
