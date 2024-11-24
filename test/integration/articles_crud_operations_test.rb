require "test_helper"

class ArticlesIntegrationTest < ActionDispatch::IntegrationTest
  test "should create, read, update, and delete an article" do
    post articles_url, params: {
      article: {
        title: "Integration Testing",
        author: "Tester",
        content: "This is a test article.",
        publish_date: "2024-11-23"
      }
    }
    assert_response :created
    created_article = JSON.parse(@response.body)
    assert_equal "Integration Testing", created_article["title"]

    get article_url(created_article["id"])
    assert_response :success
    fetched_article = JSON.parse(@response.body)
    assert_equal "Integration Testing", fetched_article["title"]

    patch article_url(created_article["id"]), params: {
      article: { title: "Updated Title" }
    }
    assert_response :success
    updated_article = JSON.parse(@response.body)
    assert_equal "Updated Title", updated_article["title"]

    delete article_url(created_article["id"])
    assert_response :no_content

    get article_url(created_article["id"])
    assert_response :not_found
  end
end
