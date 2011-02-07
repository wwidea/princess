require 'test_helper'

# Controller who's views are all in the .rhtml format
class RhtmlArticlesController < ActionController::Base
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
end


class RhtmlViewsTest < ActionController::TestCase
  def setup
    setup_db
    prepop_db
    @controller = RhtmlArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def teardown
    teardown_db
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
end
