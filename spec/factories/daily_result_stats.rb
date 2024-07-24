FactoryBot.define do
  factory :daily_result_stat do
    date { Date.today }
    subject { "Science" }
    daily_low { 80 }
    daily_high { 100 }
    result_count { 10 }
  end
end