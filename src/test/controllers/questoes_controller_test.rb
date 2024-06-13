require "test_helper"

class QuestoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @questao = questoes(:one)
  end

  test "should get index" do
    get questoes_url
    assert_response :success
  end

  test "should get new" do
    get new_questao_url
    assert_response :success
  end

  test "should create questao" do
    assert_difference("Questao.count") do
      post questoes_url, params: { questao: { tipo_questao: @questao.tipo_questao } }
    end

    assert_redirected_to questao_url(Questao.last)
  end

  test "should show questao" do
    get questao_url(@questao)
    assert_response :success
  end

  test "should get edit" do
    get edit_questao_url(@questao)
    assert_response :success
  end

  test "should update questao" do
    patch questao_url(@questao), params: { questao: { tipo_questao: @questao.tipo_questao } }
    assert_redirected_to questao_url(@questao)
  end

  test "should destroy questao" do
    assert_difference("Questao.count", -1) do
      delete questao_url(@questao)
    end

    assert_redirected_to questoes_url
  end
end
