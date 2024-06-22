require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should get forbidden" do
    get errors_forbidden_url
    assert_response :success
  end
end
