# frozen_string_literal: true

require 'rubygems'
require 'sinatra'

ENV['ROOT_PATH'] = File.expand_path('../', File.dirname(__FILE__))
require File.expand_path('application.rb', ENV['ROOT_PATH'])
