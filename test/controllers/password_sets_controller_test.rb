require "test_helper"

class PasswordSetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get password_sets_new_url
    assert_response :success
  end

  test "should get update" do
    get password_sets_update_url
    assert_response :success
  end
end
