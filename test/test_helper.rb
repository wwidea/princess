#!/usr/bin/env ruby
# encoding: UTF-8

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


class ApplicationController
  prepend_view_path File.expand_path('../../app/views', __FILE__)
end


def prepop_db
  Article.create(:title => 'Article1', :content => 'This is the first article.')
  Article.create(:title => 'Article2', :content => 'This is the second article.')
end
