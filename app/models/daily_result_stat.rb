class DailyResultStat < ApplicationRecord
  validates :subject, :date, :daily_low, :daily_high, :result_count, presence: true
end
