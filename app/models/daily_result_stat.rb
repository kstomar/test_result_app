class DailyResultStat < ApplicationRecord
  validates :subject, :date, :daily_low, :daily_high, :result_count, presence: true
  scope :this_month, -> (fetch_date_range) { where(date: fetch_date_range) }
end
