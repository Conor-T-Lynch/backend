# @Reference https://blog.thnkandgrow.com/the-secret-of-decorator-pattern/
# @Reference https://www.rubyguides.com/2015/12/ruby-time/
# @Reference https://dev.to/daviducolo/active-record-merge-3049
class ArticleDecorator
    # Decorator class to enhance the functionality of the article object
    def initialize(article)
      # Initializes the decorator with an article object
      @article = article
    end

    def formatted_publish_date
      # Formats the publish_date of an article to Month Day, Year: to make it more readable.
      @article.publish_date.strftime("%B %d, %Y")
    end

    def decorated_article
      # Combines the original articles atributes and adds a new formatted_publish_date to the article objects atributes
      @article.attributes.merge(formatted_publish_date: formatted_publish_date)
    end
end
