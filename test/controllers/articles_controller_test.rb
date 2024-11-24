require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Article.delete_all
  end

  test "should get index" do
    article = Article.create!(title: "Test Index Article", content: "Content for index", author: "Author", publish_date: "2024-11-23")

    get articles_url, as: :json

    assert_response :success

    response_data = JSON.parse(@response.body)
    assert_includes response_data.map { |article| article["title"] }, "Test Index Article"
  end

  test "should create article" do
    assert_difference("Article.count", 1) do
      post articles_url, params: { article: { title: "New Article", author: "Tester", content: "This is a test article.", publish_date: "2024-11-23" } }, as: :json
    end

    assert_response :created

    created_article = JSON.parse(@response.body)
    assert_equal "New Article", created_article["title"]
  end

  test "should show article" do
    article = Article.create!(title: "Show Article", content: "Content for show", author: "Author", publish_date: "2024-11-23")

    get article_url(article), as: :json

    assert_response :success

    fetched_article = JSON.parse(@response.body)
    assert_equal "Show Article", fetched_article["title"]
  end

  test "should update article" do
    article = Article.create!(title: "Old Title", content: "Old content", author: "Author", publish_date: "2024-11-23")

    patch article_url(article), params: { article: { title: "Updated Title" } }, as: :json

    assert_response :success

    updated_article = JSON.parse(@response.body)
    assert_equal "Updated Title", updated_article["title"]
  end

  test "should destroy article" do
    article = Article.create!(title: "Article to Delete", content: "Content for deletion", author: "Author", publish_date: "2024-11-23")

    assert_difference("Article.count", -1) do
      delete article_url(article), as: :json
    end

    assert_response :no_content

    get article_url(article), as: :json
    assert_response :not_found
  end
end
