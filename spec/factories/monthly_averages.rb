FactoryBot.define do
  factory :monthly_average do
    date { Date.today }
    subject { "Science" }
    monthly_avg_low { 80 }
    monthly_avg_high { 100 }
    monthly_result_count_used { 200 }
  end
end