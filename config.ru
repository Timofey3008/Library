# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
#require 'resque/server'

run Rails.application
#run Rack::URLMap.new "/" => AppName::Application,  "/resque" => Resque::Server.new
# run Rack::URLMap.new \
#   "/"       => Your::App.new,
#   "/resque" => Resque::Server.new