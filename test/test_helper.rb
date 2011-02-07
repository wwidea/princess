# bundler
require 'rubygems'
require 'bundler/setup'

# rails constants
RAILS_ROOT = File.dirname(__FILE__)
RAILS_ENV = 'test'

# require rails
require 'active_record'
require 'active_support'
require 'action_controller'
require 'test_help'

# require princess
$:.unshift(File.dirname(__FILE__) + '/../lib')
require File.expand_path('../../init', __FILE__)

# routes
ActionController::Routing::Routes.reload rescue nil

# database connection
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

# logs
RAILS_DEFAULT_LOGGER = Logger.new(File.join(RAILS_ROOT, '/log/test.log'))
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
ActionController::Base.logger = RAILS_DEFAULT_LOGGER
