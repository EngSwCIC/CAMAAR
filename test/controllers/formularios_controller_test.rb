require "test_helper"

class FormulariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @turma = turmas(:one)
    @disciplina = disciplinas(:one)
    @formulario = formularios(:one)
    @user.update!(password: 'password123', password_confirmation: 'password123')
    
    # Associate user with turma
    Discente.create!(nome: 'Test', matricula: @user.matricula, email: @user.email, turma: @turma)
  end

  test "should get index when logged in" do
    post login_url, params: { login: @user.email, password: 'password123' }
    get formularios_url
    assert_response :success
  end

  test "should redirect to login when not logged in" do
    get formularios_url
    assert_redirected_to login_url
  end

  test "should show formulario" do
    post login_url, params: { login: @user.email, password: 'password123' }
    get formulario_url(@formulario)
    assert_response :success
  end
end
