# spec/jobs/monthly_average_calculator_job_spec.rb
require 'rails_helper'

RSpec.describe MonthlyAverageCalculatorJob, type: :job do
  describe '#perform' do
    let(:calculator_instance) { instance_double('MonthlyAverageCalculator') }

    context 'when the job is executed successfully' do
      it 'calls the calculate_and_store_monthly_averages method on MonthlyAverageCalculator' do
        allow(MonthlyAverageCalculator).to receive(:new).and_return(calculator_instance)
        allow(calculator_instance).to receive(:calculate_and_store_monthly_averages)

        MonthlyAverageCalculatorJob.perform_now

        expect(calculator_instance).to have_received(:calculate_and_store_monthly_averages)
      end

      it 'enqueues the job' do
        expect {
          MonthlyAverageCalculatorJob.perform_later
        }.to have_enqueued_job(MonthlyAverageCalculatorJob).on_queue('default')
      end
    end

    context 'when the job fails to execute' do
      it 'does not call the calculate_and_store_monthly_averages method on MonthlyAverageCalculator if initialization fails' do
        allow(MonthlyAverageCalculator).to receive(:new).and_raise(StandardError.new("Initialization failed"))

        expect {
          MonthlyAverageCalculatorJob.perform_now
        }.to raise_error(StandardError, "Initialization failed")
      end

      it 'raises an error if calculate_and_store_monthly_averages fails' do
        allow(MonthlyAverageCalculator).to receive(:new).and_return(calculator_instance)
        allow(calculator_instance).to receive(:calculate_and_store_monthly_averages).and_raise(StandardError.new("Calculation failed"))

        expect {
          MonthlyAverageCalculatorJob.perform_now
        }.to raise_error(StandardError, "Calculation failed")
      end
    end
  end
end
