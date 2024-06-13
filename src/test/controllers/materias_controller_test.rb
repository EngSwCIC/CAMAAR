require "test_helper"

class MateriasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @materia = materias(:one)
  end

  test "should get index" do
    get materias_url
    assert_response :success
  end

  test "should get new" do
    get new_materia_url
    assert_response :success
  end

  test "should create materia" do
    assert_difference("Materia.count") do
      post materias_url, params: { materia: { code: @materia.code, nome: @materia.nome } }
    end

    assert_redirected_to materia_url(Materia.last)
  end

  test "should show materia" do
    get materia_url(@materia)
    assert_response :success
  end

  test "should get edit" do
    get edit_materia_url(@materia)
    assert_response :success
  end

  test "should update materia" do
    patch materia_url(@materia), params: { materia: { code: @materia.code, nome: @materia.nome } }
    assert_redirected_to materia_url(@materia)
  end

  test "should destroy materia" do
    assert_difference("Materia.count", -1) do
      delete materia_url(@materia)
    end

    assert_redirected_to materias_url
  end
end
