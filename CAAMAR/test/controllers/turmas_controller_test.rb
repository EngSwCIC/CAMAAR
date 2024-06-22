require "test_helper"

class TurmasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get turmas_index_url
    assert_response :success
  end
end
