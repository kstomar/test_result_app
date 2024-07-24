# spec/services/monthly_average_calculator_spec.rb
require 'rails_helper'
require 'timecop'

RSpec.describe MonthlyAverageCalculator, type: :service do
  let(:dates) do
    [
      Date.parse('2022-04-07'),
      Date.parse('2022-04-08'),
      Date.parse('2022-04-11'),
      Date.parse('2022-04-12'),
      Date.parse('2022-04-13'),
      Date.parse('2022-04-14'),
      Date.parse('2022-04-15'),
      Date.parse('2022-04-18')
    ]
  end

  let(:daily_lows) { [119.88, 123.73, 121.12, 117.22, 118.84, 120.27, 126.01, 124.30] }
  let(:daily_highs) { [126.76, 127.23, 124.52, 120.11, 119.29, 123.33, 128.77, 125.58] }
  let(:result_counts) { [18, 11, 12, 81, 22, 57, 23, 12] }

  before do
    Timecop.travel(Date.new(2022, 4, 18))
  end

  after do
    Timecop.return
  end

  def create_daily_results
    dates.each_with_index do |date, i|
      create(:daily_result_stat, date: date, subject: "Science", daily_low: daily_lows[i], daily_high: daily_highs[i], result_count: result_counts[i])
    end
  end

  describe "#calculate_and_store_monthly_averages" do
    context "when the date is the third Wednesday of the month" do
      before { create_daily_results }

      it "calculates monthly averages correctly" do
        MonthlyAverageCalculator.new.calculate_and_store_monthly_averages
        avg = MonthlyAverage.find_by(date: Date.today, subject: "Science")

        expect(avg.monthly_avg_low.to_f).to be_within(0.01).of(121.29)
        expect(avg.monthly_avg_high.to_f).to be_within(0.01).of(123.6)
        expect(avg.monthly_result_count_used.to_f).to eq(207)
      end
    end

    context "when today is not Monday" do
      before { Timecop.travel(Date.new(2022, 4, 19)) }

      it "does not run the calculation" do
        expect(MonthlyAverageCalculator.new.calculate_and_store_monthly_averages).to be_nil
        expect(MonthlyAverage.count).to eq(0)
      end
    end

    context "when today is not within the week of the third Wednesday" do
      before { Timecop.travel(Date.new(2022, 4, 25)) }

      it "does not run the calculation" do
        expect(MonthlyAverageCalculator.new.calculate_and_store_monthly_averages).to be_nil
        expect(MonthlyAverage.count).to eq(0)
      end
    end
  end
end
