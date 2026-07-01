# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Avaliacoes", type: :request do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:turma) { create_turma(nome_materia: "Cálculo 1", numero: 1, departamento: departamento) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação Geral", adm: admin.perfil_adm) }

  describe "GET /avaliacoes/pendentes" do
    it "exibe pendências apenas para participantes do público-alvo correto" do
      docente = create_usuario(nome: "Docente")
      discente = create_usuario(nome: "Discente")
      create_participacao(usuario: docente, turma: turma, tipo_participacao: :docente)
      create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente)

      create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes,
        criar_avaliacoes: true
      )

      sign_in_as(discente)
      get avaliacoes_pendentes_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(turma.nome_exibicao)
      expect(response.body).to include("Não respondido")

      sign_in_as(docente)
      get avaliacoes_pendentes_path

      expect(response.body).not_to include(template.titulo)
      expect(response.body).to include("Nenhum formulário pendente foi encontrado")
    end

    it "não exibe pendências de turmas em que o usuário não participa" do
      participante = create_usuario
      outro_usuario = create_usuario
      create_participacao(usuario: participante, turma: turma, tipo_participacao: :discente)

      outra_turma = create_turma(nome_materia: "Estrutura de Dados", numero: 1, departamento: departamento)
      create_participacao(usuario: outro_usuario, turma: outra_turma, tipo_participacao: :discente)
      create_formulario(
        turma: outra_turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes,
        criar_avaliacoes: true
      )

      sign_in_as(participante)
      get avaliacoes_pendentes_path

      expect(response.body).not_to include(outra_turma.nome_exibicao)
      expect(response.body).to include("Nenhum formulário pendente foi encontrado")
    end

    it "redireciona usuário não autenticado" do
      get avaliacoes_pendentes_path

      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET /avaliacoes/:id/responder" do
    let(:discente) { create_usuario(nome: "Discente") }
    let!(:participacao) { create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente) }
    let!(:formulario) do
      create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes,
        criar_avaliacoes: true
      )
    end
    let(:avaliacao) { formulario.avaliacoes.sole }

    it "renderiza as questões copiadas para o formulário da avaliação pendente" do
      sign_in_as(discente)

      get responder_avaliacao_path(avaliacao)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Responder Avaliação")
      formulario.questoes.each do |questao|
        expect(response.body).to include(questao.enunciado)
      end
    end

    it "redireciona quando a avaliação já foi respondida" do
      avaliacao.marcar_como_respondida!
      sign_in_as(discente)

      get responder_avaliacao_path(avaliacao)

      expect(response).to redirect_to(avaliacoes_pendentes_path)
      expect(flash[:alert]).to eq("Esta avaliação já foi respondida.")
    end

    it "redireciona quando a avaliação não pertence ao usuário" do
      outro_usuario = create_usuario
      sign_in_as(outro_usuario)

      get responder_avaliacao_path(avaliacao)

      expect(response).to redirect_to(avaliacoes_pendentes_path)
      expect(flash[:alert]).to eq("Avaliação não encontrada.")
    end
  end

  describe "POST /avaliacoes/:id/submeter" do
    let(:discente) { create_usuario(nome: "Discente") }
    let!(:participacao) { create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente) }
    let!(:formulario) do
      create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes,
        criar_avaliacoes: true
      )
    end
    let(:avaliacao) { formulario.avaliacoes.sole }
    let(:questao_discursiva) { formulario.questoes.find(&:discursiva?) }
    let(:questao_objetiva) { formulario.questoes.find(&:objetiva?) }

    it "registra respostas e marca a avaliação como respondida" do
      sign_in_as(discente)

      expect do
        post submeter_avaliacao_path(avaliacao), params: respostas_validas
      end.to change(Resposta, :count).by(2)
        .and change(Texto, :count).by(1)
        .and change(OpcaoEscolhida, :count).by(1)

      expect(response).to redirect_to(avaliacoes_pendentes_path)
      expect(flash[:notice]).to eq("Avaliação registrada com sucesso.")
      expect(avaliacao.reload).to be_respondida
    end

    it "re-renderiza quando uma questão obrigatória fica sem resposta" do
      sign_in_as(discente)

      post submeter_avaliacao_path(avaliacao), params: {
        respostas: {
          questao_discursiva.id.to_s => { texto: "Comentário" },
          questao_objetiva.id.to_s => { opcao_id: "" }
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Responder Avaliação")
      expect(flash.now[:alert]).to eq("Todas as questões obrigatórias devem ser preenchidas.")
      expect(avaliacao.reload).to be_pendente
    end

    it "redireciona quando a avaliação já foi respondida" do
      avaliacao.marcar_como_respondida!
      sign_in_as(discente)

      post submeter_avaliacao_path(avaliacao), params: respostas_validas

      expect(response).to redirect_to(avaliacoes_pendentes_path)
      expect(flash[:alert]).to eq("Esta avaliação já foi respondida.")
    end

    it "re-renderiza quando a opção informada não pertence à questão" do
      sign_in_as(discente)

      post submeter_avaliacao_path(avaliacao), params: {
        respostas: {
          questao_discursiva.id.to_s => { texto: "Comentário" },
          questao_objetiva.id.to_s => { opcao_id: "999999" }
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to eq("Todas as questões obrigatórias devem ser preenchidas.")
      expect(Resposta.count).to eq(0)
    end

    def respostas_validas
      {
        respostas: {
          questao_discursiva.id.to_s => { texto: "Comentário final" },
          questao_objetiva.id.to_s => { opcao_id: questao_objetiva.opcoes.first.id.to_s }
        }
      }
    end
  end
end
