#@Reference https://guides.rubyonrails.org/testing.html?_gl=1*11et9am*_gcl_au*MTM3MDUyMjc5MC4xNzI4NjAyNzYx*_ga*NDQ2NDI4MjAxLjE3MTcwMjMzMjg.*_ga_MBTGG7KX5Y*MTcyOTg1NTQyNS4zNC4xLjE3Mjk4NTU5MTEuMTEuMC4xOTI2MjU5NjY2
#Require the test helper to set up the testing environment
require "test_helper"
#Defines a test case for the articles controller
class ArticlesControllerTest < ActionDispatch::IntegrationTest
  #Setting up the test data before running the test
  setup do
    #Clear all articles to ensure a clean test environment
    Article.delete_all
    #Creating three sample articles to search
    @article1 = Article.create!(title: "Ruby on Rails", author: "David", content: "Rails is awesome!", publish_date: "2024-11-01")
    @article2 = Article.create!(title: "Learn Python", author: "Guido", content: "Python is versatile.", publish_date: "2024-11-15")
    @article3 = Article.create!(title: "Java Basics", author: "James", content: "Java is everywhere.", publish_date: "2024-10-20")
  end
  #Test to search for articles and return matvhing results
  test "should search and return matching articles" do
    #Performing a GET request to the articles URL with a search perameter of Ruby
    get articles_url, params: { search: "Ruby" }
    #Asserting that the response was successful
    assert_response :success
    #Parse the JSON response to extract the search results
    response_data = JSON.parse(@response.body)
    #Asserting that onlt 1 article matches 
    assert_equal 1, response_data.size
    #Asserting that the title of the article matches also
    assert_equal @article1.title, response_data.first["title"]
  end
  #Test to return all articles when the search query in empty
  test "should return all articles when search is empty" do
    #Perform a GET request to the article URL with an empty search query
    get articles_url, params: { search: "" }
    #Asserting that the response was successful
    assert_response :success
    #Parse the JSON response to extract the list of articles
    response_data = JSON.parse(@response.body)
    #Asserting that the 3 articles have been retrieved
    assert_equal 3, response_data.size
    #Ectracting the titles of the returned articles
    titles = response_data.map { |article| article["title"] }
    #Asserting that the titles match the created articles
    assert_includes titles, @article1.title
    assert_includes titles, @article2.title
    assert_includes titles, @article3.title
  end
  #Test to handle the search queries that have no matching results
  test "should return no articles for unmatched search" do
    #perform a GET request to the articles URL with a query that does not match anything
    get articles_url, params: { search: "NonExistent" }
    #Asserting that the response was successful
    assert_response :success
    #Parse the JSON response to extract the search results
    response_data = JSON.parse(@response.body)
    #Asserting that no articles are returned for the unmatched search query
    assert_equal 0, response_data.size
  end
end
