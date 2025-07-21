require "test_helper"

class User::AvaliacoesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_avaliacoes_index_url
    assert_response :success
  end
end
