#!/usr/bin/env ruby
# encoding: UTF-8

require 'test_helper'

#Controller who's views are all in the .html.erb format
class ErbArticlesController < ActionController::Base
  
  def show
    @article = Article.find(params[:id])
    
    respond_to do |format|
      format.html
      format.pdf { render :pdf => true }
    end
  end
  
  def custom_one
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf { render :pdf => 'alternate_custom_one', :filename => "custom_one.pdf" }
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
  
  
  # show
  def test_should_get_show_and_return_html
    get :show, :id => 1
    assert_response :success
    assert !@response.body.match(/^%PDF/)
  end
  
  def test_should_generate_pdf_with_no_argugments
    get :show, :id => 1, :format => 'pdf'
    assert_response :success
    assert @response.body.match(/^%PDF/)
  end
  
  
  # custom_one
  def test_articles_custom_one
    get :custom_one, :id => 1
    assert_select 'h1', 'Article1'
    get :custom_one, {:id => 1, :format => 'pdf'}
    assert @response.body.match(/^%PDF/)
    assert(@response.body.length > 30000)
  end
end
