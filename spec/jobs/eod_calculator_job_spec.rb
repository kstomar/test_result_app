require 'rails_helper'

RSpec.describe EodCalculatorJob, type: :job do
  describe '#perform' do
    let(:calculator_instance) { instance_double('EodCalculator') }

    context 'when the job is executed successfully' do
      it 'calls the calculate_and_store_daily_result method on EodCalculator' do
        allow(EodCalculator).to receive(:new).and_return(calculator_instance)
        expect(calculator_instance).to receive(:calculate_and_store_daily_result)

        EodCalculatorJob.perform_now
      end

      it 'enqueues the job' do
        expect {
          EodCalculatorJob.perform_later
        }.to have_enqueued_job(EodCalculatorJob).on_queue('default')
      end
    end

    context 'when the job fails to execute' do
      it 'does not call the calculate_and_store_daily_result method on EodCalculator if initialization fails' do
        allow(EodCalculator).to receive(:new).and_raise(StandardError.new("Initialization failed"))

        expect {
          EodCalculatorJob.perform_now
        }.to raise_error(StandardError, "Initialization failed")
      end

      it 'raises an error if calculate_and_store_daily_result fails' do
        allow(EodCalculator).to receive(:new).and_return(calculator_instance)
        allow(calculator_instance).to receive(:calculate_and_store_daily_result).and_raise(StandardError.new("Calculation failed"))

        expect {
          EodCalculatorJob.perform_now
        }.to raise_error(StandardError, "Calculation failed")
      end
    end
  end
end
