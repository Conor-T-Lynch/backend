#@Reference https://guides.rubyonrails.org/testing.html?_gl=1*11et9am*_gcl_au*MTM3MDUyMjc5MC4xNzI4NjAyNzYx*_ga*NDQ2NDI4MjAxLjE3MTcwMjMzMjg.*_ga_MBTGG7KX5Y*MTcyOTg1NTQyNS4zNC4xLjE3Mjk4NTU5MTEuMTEuMC4xOTI2MjU5NjY2
#Imports the test helper module
require "test_helper"
#Intergration test for the articles controller
class ArticlesControllerTest < ActionDispatch::IntegrationTest
  #Setup block that runs before each test to clear all existing articles to make the test run smoother
  setup do
    Article.delete_all
  end
  #Test to check an article is listed in the response
  test "should get index" do
    #Creates a new article for testing perposes
    article = Article.create!(title: "Test Index Article", content: "Content for index", author: "Author", publish_date: "2024-11-23")
    #Making a GET request to retrieve all articles
    get articles_url, as: :json
    #Asseting that the response was successful
    assert_response :success
    #Parsing the JSON response and checking if the created articles title in included
    response_data = JSON.parse(@response.body)
    assert_includes response_data.map { |article| article["title"] }, "Test Index Article"
  end
  #Test for the create article action, checking to see if an article was created
  test "should create article" do
    #Makes sure the article count has incremented by 1
    assert_difference("Article.count", 1) do
      #Making a POST request to create the article
      post articles_url, params: { article: { title: "New Article", author: "Tester", content: "This is a test article.", publish_date: "2024-11-23" } }, as: :json
    end
    #Asserting that there was a response status
    assert_response :created
    #Parsing the JSON response and checking if the created article matches the title
    created_article = JSON.parse(@response.body)
    assert_equal "New Article", created_article["title"]
  end
  #Test for the show action of the article controller, checks to see if an articles details can be retrieved
  test "should show article" do
    #Creates a new article for testing perposes
    article = Article.create!(title: "Show Article", content: "Content for show", author: "Author", publish_date: "2024-11-23")
    #Making a GET request to retrieve the article by its id
    get article_url(article), as: :json
    #Asserting that the response was successful
    assert_response :success
    #Parsing the JSON response and checking if the fetched article matches the title
    fetched_article = JSON.parse(@response.body)
    assert_equal "Show Article", fetched_article["title"]
  end
  #Test for the update action of the article controller, checks if an existing article can be updated
  test "should update article" do
    #Creates a new article for testing perposes
    article = Article.create!(title: "Old Title", content: "Old content", author: "Author", publish_date: "2024-11-23")
    #PATH eqquest to update the articles title
    patch article_url(article), params: { article: { title: "Updated Title" } }, as: :json
    #Asserting that the response was successful
    assert_response :success
    #Parsing the JSON response and checking if the articles title was updated correctly
    updated_article = JSON.parse(@response.body)
    assert_equal "Updated Title", updated_article["title"]
  end
  #Test for the destroy action of the article controller
  test "should destroy article" do
    #Creates a new article for testing perposes
    article = Article.create!(title: "Article to Delete", content: "Content for deletion", author: "Author", publish_date: "2024-11-23")
    #Makes sure that deleting an article decrements the article count by 1
    assert_difference("Article.count", -1) do
      #Making a DELETE request to destroy the article
      delete article_url(article), as: :json
    end
    #Asserting that the response was successful
    assert_response :no_content
    #Try to retrieve the deleted article to make sure it no longer exists
    get article_url(article), as: :json
    #Asserting that the article was not found
    assert_response :not_found
  end
end
