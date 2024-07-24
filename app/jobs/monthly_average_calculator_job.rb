class MonthlyAverageCalculatorJob < ApplicationJob
  queue_as :default

  def perform
    MonthlyAverageCalculator.new.calculate_and_store_monthly_averages
  end
end
