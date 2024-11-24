class ArticleDecorator
    def initialize(article)
      @article = article
    end

    def formatted_publish_date
      @article.publish_date.strftime("%B %d, %Y")
    end

    def decorated_article
      @article.attributes.merge(formatted_publish_date: formatted_publish_date)
    end
end
