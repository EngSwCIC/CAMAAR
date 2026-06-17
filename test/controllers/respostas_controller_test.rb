require "test_helper"

class RespostasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @formulario = formularios(:one)
    @pergunta = perguntas(:one)
    @user.update!(password: 'password123', password_confirmation: 'password123')
    
    # Ensure turma association for current_user.turmas in index
    Discente.create!(nome: 'Test', matricula: @user.matricula, email: @user.email, turma: @formulario.turma)
  end

  test "should create resposta" do
    post login_url, params: { login: @user.email, password: 'password123' }
    
    assert_difference("Resposta.count", 1) do
      post formulario_respostas_url(@formulario), params: { 
        respostas: { @pergunta.id.to_s => "Minha resposta" } 
      }
    end

    assert_redirected_to formularios_url
    assert_equal "Avaliação submetida com sucesso!", flash[:notice]
  end

  test "should not create if missing mandatory answer" do
    @pergunta.update!(obrigatoria: true)
    post login_url, params: { login: @user.email, password: 'password123' }
    
    assert_no_difference("Resposta.count") do
      post formulario_respostas_url(@formulario), params: { 
        respostas: { @pergunta.id.to_s => "" } 
      }
    end

    assert_response :unprocessable_entity
    assert_equal "Por favor, responda todas as questões obrigatórias", flash[:alert]
  end
end
