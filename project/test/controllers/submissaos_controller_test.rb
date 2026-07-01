require "test_helper"

class SubmissaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @submissao = submissaos(:one)
  end

  test "should get index" do
    get submissaos_url
    assert_response :success
  end

  test "should get new" do
    get new_submissao_url
    assert_response :success
  end

  test "should create submissao" do
    assert_difference("Submissao.count") do
      post submissaos_url, params: { submissao: { formulario_id: @submissao.formulario_id, participant_id: @submissao.participant_id, participant_type: @submissao.participant_type } }
    end

    assert_redirected_to submissao_url(Submissao.last)
  end

  test "should show submissao" do
    get submissao_url(@submissao)
    assert_response :success
  end

  test "should get edit" do
    get edit_submissao_url(@submissao)
    assert_response :success
  end

  test "should update submissao" do
    patch submissao_url(@submissao), params: { submissao: { formulario_id: @submissao.formulario_id, participant_id: @submissao.participant_id, participant_type: @submissao.participant_type } }
    assert_redirected_to submissao_url(@submissao)
  end

  test "should destroy submissao" do
    assert_difference("Submissao.count", -1) do
      delete submissao_url(@submissao)
    end

    assert_redirected_to submissaos_url
  end
end
