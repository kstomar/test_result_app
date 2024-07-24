class EodCalculator
  def calculate_and_store_daily_result
    # I can also do this using ruby code but I have used SQL for optimised solution.
    today_results = Result.select("MAX(marks) as daily_high, MIN(marks) as daily_low, subject, COUNT(id) as result_count,  MAX(timestamp) as date").group(:subject).today
    DailyResultStat.create(today_results.as_json)
  end
end
