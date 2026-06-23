require "test_helper"

class ProfessorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @professor = professors(:one)
  end

  test "should get index" do
    get professors_url
    assert_response :success
  end

  test "should get new" do
    get new_professor_url
    assert_response :success
  end

  test "should create professor" do
    assert_difference("Professor.count") do
      post professors_url, params: { professor: { departamento_id: @professor.departamento_id, email: @professor.email, formation: @professor.formation, matricula: @professor.matricula, name: @professor.name, password_digest: @professor.password_digest } }
    end

    assert_redirected_to professor_url(Professor.last)
  end

  test "should show professor" do
    get professor_url(@professor)
    assert_response :success
  end

  test "should get edit" do
    get edit_professor_url(@professor)
    assert_response :success
  end

  test "should update professor" do
    patch professor_url(@professor), params: { professor: { departamento_id: @professor.departamento_id, email: @professor.email, formation: @professor.formation, matricula: @professor.matricula, name: @professor.name, password_digest: @professor.password_digest } }
    assert_redirected_to professor_url(@professor)
  end

  test "should destroy professor" do
    assert_difference("Professor.count", -1) do
      delete professor_url(@professor)
    end

    assert_redirected_to professors_url
  end
end
