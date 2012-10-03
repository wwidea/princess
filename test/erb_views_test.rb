#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

class ErbArticlesControllerTest < ActionController::TestCase

  def setup
    prepop_db
  end


  # show
  test "should get show and return html" do
    get :show, :id => 1
    assert_response :success
    assert !@response.body.match(/^%PDF/)
  end

  test "should generate pdf with no argugments" do
    get :show, :id => 1, :format => 'pdf'
    assert_response :success
    assert @response.body.match(/^%PDF/)
  end


  # custom_one
  test "should get alternate_custom_one template" do
    get :custom_one, :id => 1
    assert_select 'h1', 'Article1'
    get :custom_one, {:id => 1, :format => 'pdf'}
    assert @response.body.match(/^%PDF/)
    assert(@response.body.length > 10000)
  end
end
