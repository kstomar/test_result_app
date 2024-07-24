class EodCalculator
  def calculate_and_store_daily_result
    subjects = Result.distinct.pluck(:subject)
    subjects.each do |subject|
      results = Result.where("DATE(timestamp) = ?", Date.today).where(subject: subject)
      next if results.empty?

      daily_low = results.minimum(:marks)
      daily_high = results.maximum(:marks)
      result_count = results.count
      DailyResultStat.create(date: Date.today, subject: subject, daily_low: daily_low, daily_high: daily_high, result_count: result_count)
    end
  end
end
