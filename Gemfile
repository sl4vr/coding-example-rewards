# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.3'

# Concurrent Ruby web server
gem 'puma', '4.3.12'

# Rack middleware which aborts requests running too long
gem 'rack-timeout', '0.5.1'

# Static code analyzer
gem 'rubocop', '~> 0.74.0', require: false

# A make-like build utility for Ruby
gem 'rake', require: false # avoid namespace conflict

# DSL for quickly creating web applications
gem 'sinatra', '2.2.0'

# All awesome rails features
gem 'activesupport', '6.1.7.3'

group :development, :test do
  # Manager for Procfile-based applications
  gem 'foreman', '>= 0.85.0'
  # IRB alternative
  gem 'pry', '>= 0.11.3'
  # Reloading rack development server
  gem 'shotgun', '>= 0.9.2'
end

group :test do
  # Testing DSL
  gem 'rspec', '>= 3.8.0'
end
