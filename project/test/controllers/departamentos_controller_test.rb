require "test_helper"

class DepartamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @departamento = departamentos(:one)
  end

  test "should get index" do
    get departamentos_url
    assert_response :success
  end

  test "should get new" do
    get new_departamento_url
    assert_response :success
  end

  test "should create departamento" do
    assert_difference("Departamento.count") do
      post departamentos_url, params: { departamento: { code: @departamento.code, name: @departamento.name } }
    end

    assert_redirected_to departamento_url(Departamento.last)
  end

  test "should show departamento" do
    get departamento_url(@departamento)
    assert_response :success
  end

  test "should get edit" do
    get edit_departamento_url(@departamento)
    assert_response :success
  end

  test "should update departamento" do
    patch departamento_url(@departamento), params: { departamento: { code: @departamento.code, name: @departamento.name } }
    assert_redirected_to departamento_url(@departamento)
  end

  test "should destroy departamento" do
    assert_difference("Departamento.count", -1) do
      delete departamento_url(@departamento)
    end

    assert_redirected_to departamentos_url
  end
end
