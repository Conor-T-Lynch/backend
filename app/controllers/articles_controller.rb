class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show update destroy]

  def index
    if params[:search].present?

      search_service = Articles::Search.new(params[:search])
      @articles = search_service.perform
    else

      @articles = Article.all
    end

    @decorated_articles = @articles.map { |article| ArticleDecorator.new(article).decorated_article }

    render json: @decorated_articles
  end

  def show
    decorated_article = ArticleDecorator.new(@article).decorated_article
    render json: decorated_article
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      decorated_article = ArticleDecorator.new(@article).decorated_article
      render json: decorated_article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      decorated_article = ArticleDecorator.new(@article).decorated_article
      render json: decorated_article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy!
    render json: { message: "Article deleted successfully" }, status: :no_content
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :author, :content, :publish_date)
  end
end
