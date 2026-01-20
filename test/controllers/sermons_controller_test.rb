require "test_helper"

class SermonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sermon = sermons(:one)
  end

  test "should get index" do
    get sermons_url
    assert_response :success
  end

  test "should get new" do
    get new_sermon_url
    assert_response :success
  end

  test "should create sermon" do
    assert_difference("Sermon.count") do
      post sermons_url, params: { sermon: { description: @sermon.description, link: @sermon.link, title: @sermon.title } }
    end

    assert_redirected_to sermon_url(Sermon.last)
  end

  test "should show sermon" do
    get sermon_url(@sermon)
    assert_response :success
  end

  test "should get edit" do
    get edit_sermon_url(@sermon)
    assert_response :success
  end

  test "should update sermon" do
    patch sermon_url(@sermon), params: { sermon: { description: @sermon.description, link: @sermon.link, title: @sermon.title } }
    assert_redirected_to sermon_url(@sermon)
  end

  test "should destroy sermon" do
    assert_difference("Sermon.count", -1) do
      delete sermon_url(@sermon)
    end

    assert_redirected_to sermons_url
  end
end
