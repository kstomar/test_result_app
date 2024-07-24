# spec/models/daily_result_stat_spec.rb
require 'rails_helper'

RSpec.describe DailyResultStat, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:daily_low) }
  it { should validate_presence_of(:daily_high) }
  it { should validate_presence_of(:result_count) }
end
