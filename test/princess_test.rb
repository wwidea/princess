require 'test/unit'
require 'rubygems'
gem 'activerecord', '= 2.3.4'
gem 'actionpack', '= 2.3.4'
require 'active_record'
require 'action_controller'
require 'action_controller/test_process'
ActionController::Routing::Routes.reload rescue nil
RAILS_ROOT = File.dirname(__FILE__)
$:.unshift File.join(RAILS_ROOT, '/../lib')
require 'princess'
require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

RAILS_DEFAULT_LOGGER = Logger.new(File.join(RAILS_ROOT, '/log/test.log'))
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
ActionController::Base.logger = RAILS_DEFAULT_LOGGER
RAILS_ENV = 'test'

class Article < ActiveRecord::Base
end

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

#Controller who's views are all in the .rhtml format
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
