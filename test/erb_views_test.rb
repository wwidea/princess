require 'test_helper'

#Controller who's views are all in the .html.erb format
class ErbArticlesController < ActionController::Base
  prepend_view_path File.expand_path(RAILS_ROOT + '/app/views')
  princess_provides_default_pdf
  
  def index
    @articles = Article.find(:all)
  end
  
  def show
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  def custom_one
    @article = Article.find(params[:id])
    respond_to do |format|
      format.html #default
      format.pdf do
        send_pdf(
          :template => 'erb_articles/alternate_custom_one.html.erb',
          :filename => "custom_one.pdf")
      end
    end
  end
  
  def custom_two
    @article = Article.find(params[:id])
  end
end

class ErbViewsTest < ActionController::TestCase
  
  def setup
    setup_db
    prepop_db
    @controller = ErbArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def teardown
    teardown_db
  end
  
  def test_which_prince_should_return_path_to_prince
    # why does this not work
    assert `which prince`.match(/prince$/), "which prince returned - #{`which prince`.inspect}"
  end
  
  def test_articles_index
    get :index
    assert_select 'li', 'Article1'
    get :index, {:format => 'pdf'}
    assert @response.body.match(/^%PDF/)
  end
  
  def test_articles_show
    get :show, {:id => 1}
    assert_select 'h1', 'Article1'
    get :show, {:id => 1, :format => 'pdf'}
    assert @response.body.match(/^%PDF/)
  end
  
  def test_articles_custom_one
    get :custom_one, {:id => 1}
    assert_select 'h1', 'Article1'
    get :custom_one, {:id => 1, :format => 'pdf'}
    assert @response.body.match(/^%PDF/)
    assert(@response.body.length > 30000)
  end
  
  def test_articles_custom_two
    get :custom_two, {:id => 1}
    assert_select 'h1', 'Article1'
    get :custom_two, {:id => 1, :format => 'pdf'}
    assert @response.body.match(/^%PDF/)
    assert(@response.body.length > 30000)
  end
end
