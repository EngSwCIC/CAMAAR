require "test_helper"

class TelasControllerTest < ActionDispatch::IntegrationTest
  test "should get gerenciamento" do
    get telas_gerenciamento_url
    assert_response :success
  end
end
