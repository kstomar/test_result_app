class MonthlyAverageCalculator
  def calculate_and_store_monthly_averages
    return unless run_on_monday_of_third_wednesday_week?
    DailyResultStat.distinct.pluck(:subject).each do |subject|
      stats = fetch_stats(subject)
      next if stats.empty?

      create_monthly_average(subject, stats)
    end
  end

  private

  def fetch_stats(subject)
    stats = []
    days = 0
    result_count = 0

    while result_count < 200 || stats.size <= 5
      stat = DailyResultStat.where(subject: subject, date: Date.today - days).first
      days += 1
      next unless stat

      stats << stat
      result_count += stat.result_count
    end

    stats
  end

  def create_monthly_average(subject, stats)
    monthly_avg_low = stats.sum(&:daily_low) / stats.size
    monthly_avg_high = stats.sum(&:daily_high) / stats.size
    monthly_result_count_used = stats.sum(&:result_count)

    MonthlyAverage.create(
      date: Date.today,
      subject: subject,
      monthly_avg_low: monthly_avg_low.to_f.round(2),
      monthly_avg_high: monthly_avg_high.to_f.round(2),
      monthly_result_count_used: monthly_result_count_used
    )
  end

  def run_on_monday_of_third_wednesday_week?
    today = Date.today
    return false unless today.monday?

    third_wednesday = third_wednesday_of_month(today)
    third_wednesday.beginning_of_week == today
    # third_wednesday_week = third_wednesday.beginning_of_week..third_wednesday.end_of_week

    # third_wednesday_week.cover?(today)
  end

  def third_wednesday_of_month(date)
    first_day_of_month = date.beginning_of_month
    first_wednesday = first_day_of_month + ((3 - first_day_of_month.wday) % 7).days
    first_wednesday + 14.days
  end
end