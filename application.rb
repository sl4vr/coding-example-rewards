# frozen_string_literal: true

# Main application entry point
class Application < Sinatra::Base
  get '/?' do
    erb :index
  end
end
