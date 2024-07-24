class MonthlyAverageCalculator
  def calculate_and_store_monthly_averages
    return unless run_on_monday_of_third_wednesday_week?

    ## I can also do this using ruby code but I have used SQL for optimised solution.
    daily_results = DailyResultStat.select("subject, ROUND(AVG(daily_low)::numeric, 2) as monthly_avg_low, ROUND(AVG(daily_high)::numeric, 2) as monthly_avg_high, SUM(result_count) as monthly_result_count_used, MAX(date) as date").group(:subject).this_month(fetch_date_range)
    MonthlyAverage.create(daily_results.as_json)
  end

  private

  def fetch_date_range
    end_date = Date.today
    start_date = end_date - 6.days

    minimum_required_result_count = 200

    while total_result_count(start_date, end_date) < minimum_required_result_count
      start_date -= 1.day
      break if start_date <= end_date.beginning_of_month
    end

    start_date..end_date
  end

  def total_result_count(start_date, end_date)
    DailyResultStat.where(date: start_date..end_date).sum(:result_count)
  end

  def run_on_monday_of_third_wednesday_week?
    today = Date.today
    return false unless today.monday?

    third_wednesday = third_wednesday_of_month(today)
    third_wednesday.beginning_of_week == today
  end

  def third_wednesday_of_month(date)
    first_day_of_month = date.beginning_of_month
    first_wednesday = first_day_of_month + ((3 - first_day_of_month.wday) % 7).days
    first_wednesday + 14.days
  end
end