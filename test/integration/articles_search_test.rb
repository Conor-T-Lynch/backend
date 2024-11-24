require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    
    Article.delete_all

    @article1 = Article.create!(title: "Ruby on Rails", author: "David", content: "Rails is awesome!", publish_date: "2024-11-01")
    @article2 = Article.create!(title: "Learn Python", author: "Guido", content: "Python is versatile.", publish_date: "2024-11-15")
    @article3 = Article.create!(title: "Java Basics", author: "James", content: "Java is everywhere.", publish_date: "2024-10-20")
  end

  test "should search and return matching articles" do
    
    get articles_url, params: { search: "Ruby" }
    assert_response :success

    response_data = JSON.parse(@response.body)

    assert_equal 1, response_data.size
    assert_equal @article1.title, response_data.first["title"]
  end

  test "should return all articles when search is empty" do
    
    get articles_url, params: { search: "" }
    assert_response :success

    response_data = JSON.parse(@response.body)

    assert_equal 3, response_data.size
    titles = response_data.map { |article| article["title"] }
    assert_includes titles, @article1.title
    assert_includes titles, @article2.title
    assert_includes titles, @article3.title
  end

  test "should return no articles for unmatched search" do
    
    get articles_url, params: { search: "NonExistent" }
    assert_response :success

    response_data = JSON.parse(@response.body)

    assert_equal 0, response_data.size
  end
end
