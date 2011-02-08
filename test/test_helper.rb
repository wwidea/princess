# princess rails app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../princess/config/environment', __FILE__)

# simplecov
require 'simplecov'
SimpleCov.start

# RailsEnvironment.root = File.dirname(__FILE__)
require 'rails/test_help'

# require princess
$:.unshift(File.dirname(__FILE__) + '/../lib')
require File.expand_path('../../init', __FILE__)


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
