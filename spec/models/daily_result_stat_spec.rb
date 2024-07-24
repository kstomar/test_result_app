# spec/models/daily_result_stat_spec.rb
require 'rails_helper'

RSpec.describe DailyResultStat, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:daily_low) }
  it { should validate_presence_of(:daily_high) }
  it { should validate_presence_of(:result_count) }

  describe 'scopes' do
    let!(:today) { Date.today }
    let!(:start_of_month) { today.beginning_of_month }
    let!(:end_of_month) { today.end_of_month }

    before do
      # Create records with different dates
      create(:daily_result_stat, date: start_of_month)
      create(:daily_result_stat, date: end_of_month)
      create(:daily_result_stat, date: start_of_month - 1.month) # Not in this month
    end

    describe '.this_month' do
      it 'returns records for the current month' do
        range = start_of_month..end_of_month
        expect(DailyResultStat.this_month(range).count).to eq(2)
        expect(DailyResultStat.this_month(Date.today).pluck(:date)).to all(be_between(start_of_month, end_of_month))
      end

      it 'does not return records from outside the current month' do
        range = start_of_month..end_of_month
        expect(DailyResultStat.this_month(range).pluck(:date)).not_to include(start_of_month - 1.month)
      end
    end
  end
end
