# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV.fetch('RACK_ENV', 'development').to_sym)

workers Integer(ENV['WEB_CONCURRENCY'] || 1)
min_threads = Integer(ENV['MIN_THREADS'] || 1)
max_threads = Integer(ENV['MAX_THREADS'] || 1)

threads(min_threads, max_threads)
preload_app!

port(ENV['PORT'] || 3000)
environment(ENV['RACK_ENV'] || 'development')
