#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

#Controller who's views are all in the .html.erb format
class ErbArticlesController < ActionController::Base
  
  def custom_one
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html #default
      format.pdf { render :pdf => {
        :template => 'erb_articles/alternate_custom_one',
        :filename => "custom_one.pdf"
      }}
    end
  end
end

class ErbViewsTest < ActionController::TestCase
  
  def setup
    prepop_db
    @controller = ErbArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_which_prince_should_return_path_to_prince
    # why does this not work
    assert `which prince`.match(/prince$/), "which prince returned - #{`which prince`.inspect}"
  end
  
  def test_articles_custom_one
    get :custom_one, {:id => 1}
    assert_select 'h1', 'Article1'
    get :custom_one, {:id => 1, :format => 'pdf'}
    assert @response.body.match(/^%PDF/)
    assert(@response.body.length > 30000)
  end
end
