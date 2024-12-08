# @Reference https://guides.rubyonrails.org/testing.html?_gl=1*11et9am*_gcl_au*MTM3MDUyMjc5MC4xNzI4NjAyNzYx*_ga*NDQ2NDI4MjAxLjE3MTcwMjMzMjg.*_ga_MBTGG7KX5Y*MTcyOTg1NTQyNS4zNC4xLjE3Mjk4NTU5MTEuMTEuMC4xOTI2MjU5NjY2
# Requires the test helper to set up the testing enviroment
require "test_helper"
# Defines an intergration test for articles controller
class ArticlesIntegrationTest < ActionDispatch::IntegrationTest
  # Test for creating, reading, updating and deleting an article
  test "should create, read, update, and delete an article" do
    # Creating an article with valid perameters via a POST request
    post articles_url, params: {
      article: {
        title: "Integration Testing",
        author: "Tester",
        content: "This is a test article.",
        publish_date: "2024-11-23"
      }
    }
    # Asserting that the response was successful
    assert_response :created
    # Parsing the JSON response to extract the articles details
    created_article = JSON.parse(@response.body)
    # checking if the created articles title in included
    assert_equal "Integration Testing", created_article["title"]
    # test reading the created article by sending a GET request
    get article_url(created_article["id"])
    # Asserting that the response was successful
    assert_response :success
    # Parsing the JSON response to extract the articles details
    fetched_article = JSON.parse(@response.body)
    # Asserting that the title of the fecthed article matches
    assert_equal "Integration Testing", fetched_article["title"]
    # Test updating the article title via a PATCH request
    patch article_url(created_article["id"]), params: {
      # Updates the article title
      article: { title: "Updated Title" }
    }
    # Asserting that the response was successful
    assert_response :success
    # Parsing the JSON response to extract the updated articles details
    updated_article = JSON.parse(@response.body)
    # Asserting that the title of the updated article matches
    assert_equal "Updated Title", updated_article["title"]
    # Test deleting an article by sending a delete request
    delete article_url(created_article["id"])
    # Asserting that there is no content returned after deletion
    assert_response :no_content
    # Test fetching the deleted article via a GET request
    get article_url(created_article["id"])
    # Assert that the response indicates that the article was not found
    assert_response :not_found
  end
end
