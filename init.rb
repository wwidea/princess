#!/usr/bin/env ruby
# encoding: UTF-8

# Include hook code here
require 'princess'
Mime::Type.register "application/pdf", :pdf
ActionController::Base.send(:include, Princess)
