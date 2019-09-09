# frozen_string_literal: true

require 'rack-timeout'
require_relative 'boot'

use Rack::Timeout, service_timeout: ENV.fetch('RACK_TIMEOUT', 900)

run Application
