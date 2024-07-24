class EodCalculatorJob < ApplicationJob
  queue_as :default

  def perform
    EodCalculator.new.calculate_and_store_daily_result
  end
end
