class ResultsController < ApplicationController
  protect_from_forgery with: :null_session
  
  def create
    result = Result.new(result_params)
    if result.save
      render json: result, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  private

  def result_params
    params.require(:result).permit(:subject, :timestamp, :marks)
  end
end
