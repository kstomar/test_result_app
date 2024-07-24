require 'rails_helper'

RSpec.describe MonthlyAverage, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:monthly_avg_low) }
  it { should validate_presence_of(:monthly_avg_high) }
  it { should validate_presence_of(:monthly_result_count_used) }
end
