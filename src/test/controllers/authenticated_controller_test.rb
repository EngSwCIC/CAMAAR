require "test_helper"

class AuthenticatedControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get authenticated_home_url
    assert_redirected_to login_path
  end
end
