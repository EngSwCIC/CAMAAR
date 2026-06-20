require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get gerenciamento" do
    get pages_gerenciamento_url
    assert_response :success
  end

  test "should get avaliacoes" do
    get pages_avaliacoes_url
    assert_response :success
  end
end
