# @Reference https://stackoverflow.com/questions/49485384/ruby-on-rails-how-to-implement-search-function
# @Reference https://www.youtube.com/watch?v=utuVo6xKIOs&ab_channel=MalachiRails
# Defines the articles module which contains the search function
module Articles
  # Search class that performs the search operations
  class Search
    # Initialize the class with a query perameter and is used to store the searched term
    def initialize(query)
      @query = query
    end

    def perform
      # If query is not empty, perform a search
      if @query.present?
        # Where clause to filter the articles that match the query, either by title, content or author
        Article.where("title LIKE ? OR content LIKE ? OR author LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
      else
        # If the query is empty return all articles
        Article.all
      end
    end
  end
end
