require 'rails_helper'

RSpec.describe Result, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:timestamp) }
  it { should validate_presence_of(:marks) }

  describe 'scopes' do
    let!(:today) { Date.today }
    let!(:yesterday) { today - 1.day }
    let!(:tomorrow) { today + 1.day }

    before do
      # Create records with different timestamps
      create(:result, timestamp: today)
      create(:result, timestamp: yesterday)
      create(:result, timestamp: tomorrow)
    end

    describe '.today' do
      it 'returns records with timestamps from today' do
        expect(Result.today.count).to eq(1)
        expect(Result.today.pluck(:timestamp)).to all(be_between(today.beginning_of_day, today.end_of_day))
      end

      it 'does not return records with timestamps from yesterday' do
        expect(Result.today.pluck(:timestamp)).not_to include(yesterday)
      end

      it 'does not return records with timestamps from tomorrow' do
        expect(Result.today.pluck(:timestamp)).not_to include(tomorrow)
      end
    end
  end
end
