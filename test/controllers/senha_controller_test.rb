require "test_helper"

class SenhaControllerTest < ActionDispatch::IntegrationTest
  test "should get redefinir" do
    get senha_redefinir_url
    assert_response :success
  end
end
