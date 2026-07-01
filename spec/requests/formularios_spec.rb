require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  before(:each) do
    @pessoa = Pessoa.create!(usuario: '101010101', email: 'ganso@unb.br', nome: 'Paulo Henrique Ganso', password: '123', password_confirmation: '123')
    @discente = Discente.create!(pessoa: @pessoa, matricula: '101010101')
    
    pessoa_prof = Pessoa.create!(usuario: 'prof2', email: 'gordiola@unb.br', nome: 'Gordiola', password: '123', password_confirmation: '123')
    docente = Docente.create!(pessoa: pessoa_prof)
    disciplina = Disciplina.create!(codigo: 'CIC0097', nome: 'Bancos de Dados')
    turma = Turma.create!(codigo: 'TA', disciplina: disciplina, docente: docente)
    
    template = Template.create!(nome: 'Feedback Semestral', pessoa: pessoa_prof)
    @formulario = Formulario.create!(turma: turma, template: template, status: :aberto)
    @questao = Questao.create!(formulario: @formulario, enunciado: 'Nota para a didática', tipo_resposta: :texto)

    post login_path, params: { login: 'ganso@unb.br', password: '123' }
  end

  describe "GET /formularios/:id" do
    it "retorna sucesso ao acessar o formulário" do
      get formulario_path(@formulario)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /formularios/:id/responder" do
    context "Happy Path" do
      it "salva as respostas com sucesso e redireciona para a rota correta" do
        post responder_formulario_path(@formulario), params: { 
          respostas: { @questao.id.to_s => { conteudo: "O professor domina o assunto!" } }
        }
        
        expect(response).to redirect_to(formulario_path(@formulario)).or(redirect_to(root_path))
      end
    end

    context "Sad Path" do
      it "falha ao tentar enviar uma resposta sem conteúdo (simulando erro de validação de banco)" do
        post responder_formulario_path(@formulario), params: { 
          respostas: { "" => "Resposta fantasma" } 
        }
        
        expect(Resposta.count).to eq(0)
        expect(response).to redirect_to(formulario_path(@formulario))
        expect(flash[:alert]).to eq("Erro ao enviar avaliação. Tente novamente.")
      end
    end
  end
end