require "test_helper"

class Public::IdeasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_ideas_index_url
    assert_response :success
  end

  test "should get new" do
    get public_ideas_new_url
    assert_response :success
  end

  test "should get create" do
    get public_ideas_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_ideas_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_ideas_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_ideas_destroy_url
    assert_response :success
  end

  test "should get tags" do
    get public_ideas_tags_url
    assert_response :success
  end

  test "should get search" do
    get public_ideas_search_url
    assert_response :success
  end
end
