module Articles
  class Search
    def initialize(query)
      @query = query
    end

    def perform
      if @query.present?
        
        Article.where("title LIKE ? OR content LIKE ? OR author LIKE ?", 
                      "%#{@query}%", "%#{@query}%", "%#{@query}%")
      else
        Article.all
      end
    end
  end
end
