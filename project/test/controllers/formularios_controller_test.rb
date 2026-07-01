require "test_helper"

class FormulariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @formulario = formularios(:one)
  end

  test "should get index" do
    get formularios_url
    assert_response :success
  end

  test "should get new" do
    get new_formulario_url
    assert_response :success
  end

  test "should create formulario" do
    assert_difference("Formulario.count") do
      post formularios_url, params: { formulario: { admin_id: @formulario.admin_id, status: @formulario.status, target_role: @formulario.target_role, template_id: @formulario.template_id, title: @formulario.title, turma_id: @formulario.turma_id } }
    end

    assert_redirected_to formularios_url
  end

  test "should show formulario" do
    get formulario_url(@formulario)
    assert_response :success
  end

  test "should get edit" do
    get edit_formulario_url(@formulario)
    assert_response :success
  end

  test "should update formulario" do
    patch formulario_url(@formulario), params: { formulario: { admin_id: @formulario.admin_id, status: @formulario.status, target_role: @formulario.target_role, template_id: @formulario.template_id, title: @formulario.title, turma_id: @formulario.turma_id } }
    assert_redirected_to formulario_url(@formulario)
  end

  test "should destroy formulario" do
    assert_difference("Formulario.count", -1) do
      delete formulario_url(@formulario)
    end

    assert_redirected_to formularios_url
  end
end
