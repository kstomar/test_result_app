class Result < ApplicationRecord
  validates :subject, :timestamp, :marks, presence: true
end
