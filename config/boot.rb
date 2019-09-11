# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'active_support/all'

ENV['ROOT_PATH'] = File.expand_path('../', File.dirname(__FILE__))
require File.expand_path('application.rb', ENV['ROOT_PATH'])

lib_files = File.join(ENV['ROOT_PATH'], %w[lib ** *.rb])
Dir.glob(lib_files).each { |f| require f }
