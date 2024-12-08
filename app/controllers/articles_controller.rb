# @Reference https://guides.rubyonrails.org/action_controller_overview.html
# @Reference https://stackoverflow.com/questions/51939922/rails-search-by-params-not-working-issue-with-associations
class ArticlesController < ApplicationController
  # Uses the before_action to set the article instance variable for specific actions
  before_action :set_article, only: %i[show update destroy]
  # GET /articles
  def index
    # If a search perameter in present, search term initialized to filter the articles
    if params[:search].present?

      search_service = Articles::Search.new(params[:search])
      @articles = search_service.perform
    else
      # else fetch all articles
      @articles = Article.all
    end
    # Decorate each article to add additional presentation logic
    @decorated_articles = @articles.map { |article| ArticleDecorator.new(article).decorated_article }
    # render in JSON
    render json: @decorated_articles
  end
  # GET /article/:id
  def show
    # Decorate each article to add additional presentation logic
    decorated_article = ArticleDecorator.new(@article).decorated_article
    # render in JSON
    render json: decorated_article
  end
  # Post /articles
  def create
    # Create new article instance with provided perameters
    @article = Article.new(article_params)
    # If article is sucessfully saved, decorate it and render it in JSON
    if @article.save
      decorated_article = ArticleDecorator.new(@article).decorated_article
      render json: decorated_article, status: :created, location: @article
    else
      # If the article was not saved sucessfully render the errors as JSON
      render json: @article.errors, status: :unprocessable_entity
    end
  end
  # PUT / PATCH /articles/:id
  def update
    # Update the article with provided perameters
    if @article.update(article_params)
      # If article is sucessfully updated, decorate it and render it in JSON
      decorated_article = ArticleDecorator.new(@article).decorated_article
      render json: decorated_article
    else
      # If the update was not sucessful render the errors as JSON
      render json: @article.errors, status: :unprocessable_entity
    end
  end
  # DELETE /articles/:id
  def destroy
    # Destroy article instance
    @article.destroy!
    # Render a success message as jason
    render json: { message: "Article deleted successfully" }, status: :no_content
  end

  private
  # Callback to find and set the article based on the ID perameter
  def set_article
    @article = Article.find(params[:id])
  end
  # Method to whitelist the allowed attributes for an article
  def article_params
    params.require(:article).permit(:title, :author, :content, :publish_date)
  end
end
