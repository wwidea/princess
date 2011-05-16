#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class Foo
  include Princess::GeneratePdf
  
  def params
    @params ||= Hash.new
  end
end

class GeneratePdfTest < ActiveSupport::TestCase
  
  # append_suffix
  test "should append suffix" do
    instance = Foo.new
    
    assert_equal 'foo.bar', instance.send(:append_suffix, 'foo', :bar)
  end
  
  test "should not append when suffix is already present" do
    instance = Foo.new
    
    assert_equal 'foo.bar', instance.send(:append_suffix, 'foo.bar', :bar)
  end
  
  
  # princess_default_stylesheet
  test "should return application pdf stylesheet" do
    instance = Foo.new
    instance.params[:controller] = 'does_not_exist'
    
    assert_equal 'application_default_pdf', instance.send(:princess_default_stylesheet)
  end

  test "should return controller specific pdf stylesheet" do
    instance = Foo.new
    instance.params[:controller] = 'reports'
    
    assert_equal 'reports_default_pdf', instance.send(:princess_default_stylesheet)
  end
  
  
  # princess_default_filename
  test "should return princess_default_filename" do
    instance = Foo.new
    instance.params[:controller] = 'foo'
    instance.params[:action] = 'bar'
    
    assert_equal 'foo_bar.pdf', instance.send(:princess_default_filename)
  end
end
