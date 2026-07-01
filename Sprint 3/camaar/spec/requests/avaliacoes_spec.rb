require 'rails_helper'

RSpec.describe 'Avaliacoes', type: :request do
  let!(:admin) { User.create!(name: 'Admin', email: 'admin@unb.br', password: 'senha123', role: 'admin', department: 'CIC') }
  let!(:aluno) { User.create!(name: 'Aluno', email: 'aluno@unb.br', password: 'senha123', role: 'user') }
  let!(:disciplina) { Disciplina.create!(codigo: 'CIC0097', nome: 'Banco de Dados', department: 'CIC') }
  let!(:turma) { Turma.create!(disciplina: disciplina, codigo: 'TA', semestre: '2026.1', horario: '35T45') }
  let!(:template) do
    t = Template.new(titulo: 'Avaliação Semestral')
    t.questoes.build(enunciado: 'Como você avalia a disciplina?')
    t.save!
    t
  end
  let!(:avaliacao) do
    Avaliacao.create!(template: template, turma: turma, tipo: 'discente',
                      data_inicio: Date.today, data_fim: Date.tomorrow)
  end

  # ── Issue #113: Criação de formulário para docentes ou discentes ────────────

  describe 'GET /avaliacoes/new (#113)' do
    context 'admin autenticado' do
      it 'exibe formulário de criação com seleção de tipo' do
        sign_in admin
        get '/avaliacoes/new'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Discentes')
        expect(response.body).to include('Docentes')
        expect(response.body).to include('Template')
        expect(response.body).to include('Turma')
      end
    end

    context 'usuário comum' do
      it 'redireciona para o dashboard' do
        sign_in aluno
        get '/avaliacoes/new'

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'não autenticado' do
      it 'redireciona para login' do
        get '/avaliacoes/new'
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'POST /avaliacoes (#113)' do
    let(:params_validos) do
      {
        avaliacao: {
          template_id: template.id,
          turma_id:    turma.id,
          tipo:        'discente',
          data_inicio: Date.today.to_s,
          data_fim:    Date.tomorrow.to_s
        }
      }
    end

    context 'admin autenticado' do
      before { sign_in admin }

      it 'cria avaliacao para discentes e redireciona' do
        expect {
          post '/avaliacoes', params: params_validos
        }.to change(Avaliacao, :count).by(1)

        expect(response).to redirect_to(avaliacoes_path)
        expect(Avaliacao.last.tipo).to eq('discente')
      end

      it 'cria avaliacao para docentes' do
        params = params_validos.deep_merge(avaliacao: { tipo: 'docente' })
        post '/avaliacoes', params: params

        expect(Avaliacao.last.tipo).to eq('docente')
      end

      it 'não cria com tipo inválido' do
        params = params_validos.deep_merge(avaliacao: { tipo: 'invalido' })
        expect {
          post '/avaliacoes', params: params
        }.not_to change(Avaliacao, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'não cria sem template' do
        params = params_validos.deep_merge(avaliacao: { template_id: nil })
        expect {
          post '/avaliacoes', params: params
        }.not_to change(Avaliacao, :count)
      end

      it 'não cria sem turma' do
        params = params_validos.deep_merge(avaliacao: { turma_id: nil })
        expect {
          post '/avaliacoes', params: params
        }.not_to change(Avaliacao, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'usuário comum' do
      it 'é bloqueado e não cria avaliacao' do
        sign_in aluno
        expect {
          post '/avaliacoes', params: params_validos
        }.not_to change(Avaliacao, :count)
      end
    end
  end

  # ── Issue #109: Visualização de formulários para responder ─────────────────

  describe 'GET /avaliacoes (#109)' do
    context 'não autenticado' do
      it 'redireciona para login' do
        get '/avaliacoes'
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'aluno matriculado na turma' do
      before do
        TurmaAluno.create!(turma: turma, aluno_id: aluno.id)
        sign_in aluno
      end

      it 'exibe o formulário disponível' do
        get '/avaliacoes'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Avaliação Semestral')
        expect(response.body).to include('Banco de Dados')
      end

      it 'não exibe formulário já respondido' do
        questao = template.questoes.first
        Resposta.create!(user: aluno, avaliacao: avaliacao, questao: questao, texto: 'Ótima')
        get '/avaliacoes'

        expect(response.body).to include('Nenhum formulário disponível')
        expect(response.body).not_to include(responder_avaliacao_path(avaliacao))
      end

      it 'não exibe formulários do tipo docente' do
        Avaliacao.create!(template: template, turma: turma, tipo: 'docente',
                          data_inicio: Date.today, data_fim: Date.tomorrow)
        get '/avaliacoes'

        expect(response.body).to include(responder_avaliacao_path(avaliacao))
        expect(response.body).not_to include("/avaliacoes/#{Avaliacao.last.id}/responder")
      end
    end

    context 'aluno não matriculado na turma' do
      before { sign_in aluno }

      it 'não exibe formulários de turmas alheias' do
        get '/avaliacoes'

        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include('Avaliação Semestral')
      end
    end

    context 'admin autenticado' do
      before { sign_in admin }

      it 'exibe todos os formulários criados' do
        get '/avaliacoes'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Avaliação Semestral')
        expect(response.body).to include('Novo Formulário')
      end
    end
  end

  # ── Issue #99: Responder formulário ────────────────────────────────────────

  describe 'GET /avaliacoes/:id/responder (#99)' do
    before do
      TurmaAluno.create!(turma: turma, aluno_id: aluno.id)
      sign_in aluno
    end

    it 'exibe as questões do formulário' do
      get "/avaliacoes/#{avaliacao.id}/responder"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Como você avalia a disciplina?')
      expect(response.body).to include('Enviar Respostas')
    end

    it 'redireciona quando o formulário já foi respondido' do
      Resposta.create!(user: aluno, avaliacao: avaliacao,
                       questao: template.questoes.first, texto: 'Respondido')

      get "/avaliacoes/#{avaliacao.id}/responder"

      expect(response).to redirect_to(avaliacoes_path)
      expect(flash[:alert]).to include('já respondeu')
    end
  end

  describe 'POST /avaliacoes/:id/submeter (#99)' do
    let(:questao) { template.questoes.first }

    before do
      TurmaAluno.create!(turma: turma, aluno_id: aluno.id)
      sign_in aluno
    end

    it 'salva respostas e redireciona com sucesso' do
      expect {
        post "/avaliacoes/#{avaliacao.id}/submeter",
             params: { respostas: { questao.id.to_s => 'Disciplina excelente!' } }
      }.to change(Resposta, :count).by(1)

      expect(response).to redirect_to(avaliacoes_path)
      expect(flash[:notice]).to include('Respostas enviadas')
    end

    it 'impede submissão duplicada' do
      Resposta.create!(user: aluno, avaliacao: avaliacao, questao: questao, texto: 'Primeira')

      expect {
        post "/avaliacoes/#{avaliacao.id}/submeter",
             params: { respostas: { questao.id.to_s => 'Segunda tentativa' } }
      }.not_to change(Resposta, :count)

      expect(response).to redirect_to(avaliacoes_path)
      expect(flash[:alert]).to include('já respondeu')
    end

    it 'rejeita resposta sem texto' do
      expect {
        post "/avaliacoes/#{avaliacao.id}/submeter",
             params: { respostas: { questao.id.to_s => '' } }
      }.not_to change(Resposta, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejeita submissão sem respostas' do
      expect {
        post "/avaliacoes/#{avaliacao.id}/submeter"
      }.not_to change(Resposta, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash[:alert]).to include('Preencha todas as questões')
    end
  end

  # ── Issue #110: Visualização de resultados dos formulários ─────────────────

  describe 'GET /avaliacoes/:id/resultados (#110)' do
    let(:questao) { template.questoes.first }

    context 'admin autenticado' do
      before { sign_in admin }

      it 'exibe resultados sem respostas' do
        get "/avaliacoes/#{avaliacao.id}/resultados"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Avaliação Semestral')
        expect(response.body).to include('0 respondente(s)')
      end

      it 'exibe as respostas recebidas por questão' do
        outro = User.create!(name: 'Outro', email: 'outro@unb.br', password: 'senha123', role: 'user')
        Resposta.create!(user: aluno,  avaliacao: avaliacao, questao: questao, texto: 'Muito boa')
        Resposta.create!(user: outro, avaliacao: avaliacao, questao: questao, texto: 'Razoável')

        get "/avaliacoes/#{avaliacao.id}/resultados"

        expect(response.body).to include('Muito boa')
        expect(response.body).to include('Razoável')
        expect(response.body).to include('2 respondente(s)')
      end

      it 'exibe a questão do template' do
        get "/avaliacoes/#{avaliacao.id}/resultados"
        expect(response.body).to include('Como você avalia a disciplina?')
      end
    end

    context 'usuário comum' do
      it 'redireciona para o dashboard' do
        sign_in aluno
        get "/avaliacoes/#{avaliacao.id}/resultados"

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'não autenticado' do
      it 'redireciona para login' do
        get "/avaliacoes/#{avaliacao.id}/resultados"

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
