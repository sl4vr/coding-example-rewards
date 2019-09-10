# frozen_string_literal: true

# Main application entry point
class Application < Sinatra::Base
  get '/?' do
    erb :index
  end

  post '/upload' do
    file = params[:file][:tempfile]
    log = File.read(file)

    customer_repository = Rewards::CustomerRepository.new
    recommendation_repository = Rewards::RecommendationRepository.new
    log_parser = Rewards::Parser

    calculator = Rewards::Calculator.new(
      input: log,
      parser: log_parser,
      customers: customer_repository,
      recommendations: recommendation_repository
    )

    @scores = calculator.calculate

    @scores.to_json
  end
end
