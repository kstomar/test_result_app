Given("the system has the following daily result stats:") do |table|
  table.hashes.each do |row|
    DailyResultStat.create!(
      date: Date.parse(row['date']),
      subject: row['subject'],
      daily_low: row['daily_low'],
      daily_high: row['daily_high'],
      result_count: row['result_count']
    )
  end
end

Given("today is {string}") do |date|
  Timecop.freeze(Date.parse(date))
end

When("MSM submits the following results:") do |table|
  table.hashes.each do |row|
    post results_data_path, { result: row }, headers: { 'Content-Type': 'application/json' }
  end
end

Then("the daily result stats for {string} should be:") do |date, table|
  expected_stats = table.hashes.last
  daily_result_stat = DailyResultStat.find_by(date: Date.parse(date), subject: expected_stats['subject'])
  expect(daily_result_stat.daily_low).to eq(expected_stats['daily_low'].to_f)
  expect(daily_result_stat.daily_high).to eq(expected_stats['daily_high'].to_f)
  expect(daily_result_stat.result_count.to_i).to eq(expected_stats['result_count'].to_i)
end

When("the system calculates monthly averages") do
  MonthlyAverageCalculator.new.calculate_and_store_monthly_averages
end

Then("the monthly averages for {string} should be:") do |date, table|
  expected_averages = table.hashes.first
  monthly_average = MonthlyAverage.find_by(date: Date.parse(date), subject: expected_averages['subject'])
  expect(monthly_average.monthly_avg_low).to eq(expected_averages['monthly_avg_low'].to_f)
  expect(monthly_average.monthly_avg_high).to eq(expected_averages['monthly_avg_high'].to_f)
  expect(monthly_average.monthly_result_count_used).to eq(expected_averages['monthly_result_count_used'].to_i)
end
