require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  test "should get new" do
    get create_url
    assert_response :success
  end

  test "should get create" do
    get register_url
    assert_response :success
  end
end
