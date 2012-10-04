#Controller who's views are all in the .html.erb format
class ErbArticlesController < ApplicationController

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
      format.pdf { render :pdf => 'erb_articles/alternate_custom_one', :filename => "custom_one.pdf" }
    end
  end
end