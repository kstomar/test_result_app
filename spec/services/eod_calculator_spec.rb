require 'rails_helper'

RSpec.describe EodCalculator, type: :service do
  describe '#calculate_and_store_daily_result' do
    let(:subject_1) { 'Math' }
    let(:subject_2) { 'Science' }

    let!(:result_1) { create(:result, subject: subject_1, marks: 70, timestamp: Date.today) }
    let!(:result_2) { create(:result, subject: subject_1, marks: 80, timestamp: Date.today) }
    let!(:result_3) { create(:result, subject: subject_2, marks: 90, timestamp: Date.today) }
    let!(:result_4) { create(:result, subject: subject_2, marks: 95, timestamp: Date.today) }

    let!(:old_result) { create(:result, subject: subject_1, marks: 60, timestamp: Date.yesterday) }

    subject { described_class.new }

    context 'when there are results for today' do
      it 'calculates and creates daily result stats for each subject' do
        subject.calculate_and_store_daily_result

        expect(DailyResultStat.count).to eq(2)

        math_stat = DailyResultStat.find_by(subject: subject_1)
        expect(math_stat.daily_low).to eq(70)
        expect(math_stat.daily_high).to eq(80)
        expect(math_stat.result_count).to eq(2)

        science_stat = DailyResultStat.find_by(subject: subject_2)
        expect(science_stat.daily_low).to eq(90)
        expect(science_stat.daily_high).to eq(95)
        expect(science_stat.result_count).to eq(2)
      end
    end

    context 'when there are no results for today' do
      before do
        Result.where("DATE(timestamp) = ?", Date.today).delete_all
      end

      it 'does not create any daily result stats' do
        expect { subject.calculate_and_store_daily_result }.not_to change { DailyResultStat.count }
      end
    end

    context 'when there are results for today but only for one subject' do
      before do
        Result.where(subject: subject_2).delete_all
      end

      it 'creates daily result stats only for the subject with results' do
        subject.calculate_and_store_daily_result

        expect(DailyResultStat.count).to eq(1)

        math_stat = DailyResultStat.find_by(subject: subject_1)
        expect(math_stat.daily_low).to eq(70)
        expect(math_stat.daily_high).to eq(80)
        expect(math_stat.result_count).to eq(2)
      end
    end

    context 'when results have the same marks' do
      let!(:result_5) { create(:result, subject: subject_1, marks: 70, timestamp: Date.today) }

      it 'correctly calculates daily low and high as the same value' do
        subject.calculate_and_store_daily_result

        expect(DailyResultStat.count).to eq(2)

        math_stat = DailyResultStat.find_by(subject: subject_1)
        expect(math_stat.daily_low).to eq(70)
        expect(math_stat.daily_high).to eq(80)
        expect(math_stat.result_count).to eq(3)
      end
    end
  end
end
