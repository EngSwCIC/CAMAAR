require "test_helper"

class MateriaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @materium = materia(:one)
  end

  test "should get index" do
    get materia_index_url, as: :json
    assert_response :success
  end

  test "should create materium" do
    assert_difference("Materia.count") do
      post materia_index_url, params: { materium: { codigo: @materium.codigo, nome: @materium.nome } }, as: :json
    end

    assert_response :created
  end

  test "should show materium" do
    get materium_url(@materium), as: :json
    assert_response :success
  end

  test "should update materium" do
    patch materium_url(@materium), params: { materium: { codigo: @materium.codigo, nome: @materium.nome } }, as: :json
    assert_response :success
  end

  test "should destroy materium" do
    assert_difference("Materia.count", -1) do
      delete materium_url(@materium), as: :json
    end

    assert_response :no_content
  end
end
