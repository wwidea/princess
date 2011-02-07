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

class ApplicationController < ActionController::Base
  prepend_view_path File.expand_path('../../app/views', __FILE__)
  prepend_view_path File.expand_path(RAILS_ROOT + '/app/views')
end


class Article < ActiveRecord::Base
end

def setup_db
  #Supress annoying Schema creation output when tests run
  old_stdout = $stdout
  $stdout = StringIO.new

  ActiveRecord::Schema.define(:version => 1) do
    create_table :articles do |t|
      t.string :title
      t.text   :content
      t.timestamps
    end
  end
  
  #Re-enable stdout
  $stdout = old_stdout
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
  
def prepop_db
  Article.create(:title => 'Article1', :content => 'This is the first article.')
  Article.create(:title => 'Article2', :content => 'This is the second article.')
end
