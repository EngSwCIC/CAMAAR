require "test_helper"

class AlunosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aluno = alunos(:one)
  end

  test "should get index" do
    get alunos_url
    assert_response :success
  end

  test "should get new" do
    get new_aluno_url
    assert_response :success
  end

  test "should create aluno" do
    assert_difference("Aluno.count") do
      post alunos_url, params: { aluno: { course: @aluno.course, email: @aluno.email, matricula: @aluno.matricula, name: @aluno.name, password_digest: @aluno.password_digest } }
    end

    assert_redirected_to aluno_url(Aluno.last)
  end

  test "should show aluno" do
    get aluno_url(@aluno)
    assert_response :success
  end

  test "should get edit" do
    get edit_aluno_url(@aluno)
    assert_response :success
  end

  test "should update aluno" do
    patch aluno_url(@aluno), params: { aluno: { course: @aluno.course, email: @aluno.email, matricula: @aluno.matricula, name: @aluno.name, password_digest: @aluno.password_digest } }
    assert_redirected_to aluno_url(@aluno)
  end

  test "should destroy aluno" do
    assert_difference("Aluno.count", -1) do
      delete aluno_url(@aluno)
    end

    assert_redirected_to alunos_url
  end
end
