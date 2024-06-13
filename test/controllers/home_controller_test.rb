require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  test "should get index" do
    get home_url
    assert_response :success
  end
end
