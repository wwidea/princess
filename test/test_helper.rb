require 'test/unit'
require 'rubygems'
gem 'activerecord', '= 3.0.3'
gem 'actionpack', '= 3.0.3'
require 'sqlite3'
require 'active_record'
require 'action_controller'
# require 'action_controller/test_process'
ActionController::Routing::Routes.reload rescue nil
RAILS_ROOT = File.dirname(__FILE__)
$:.unshift File.join(RAILS_ROOT, '/../lib')
require 'princess'
require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

RAILS_DEFAULT_LOGGER = Logger.new(File.join(RAILS_ROOT, '/log/test.log'))
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
ActionController::Base.logger = RAILS_DEFAULT_LOGGER
RAILS_ENV = 'test'
