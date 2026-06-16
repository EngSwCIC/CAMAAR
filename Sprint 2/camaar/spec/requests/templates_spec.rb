require 'rails_helper'

RSpec.describe 'Templates', type: :request do
  let!(:admin) { User.create!(name: 'Admin', email: 'admin@unb.br', password: 'senha123', role: 'admin', department: 'CIC') }
  let!(:aluno) { User.create!(name: 'Aluno', email: 'aluno@unb.br', password: 'senha123', role: 'user') }

  let!(:template) do
    t = Template.new(titulo: 'Avaliação de Turma')
    t.questoes.build(enunciado: 'Avalie a didática do professor')
    t.save!
    t
  end

  let(:params_validos) do
    {
      template: {
        titulo: 'Novo Template',
        questoes_attributes: { '0' => { enunciado: 'Primeira questão' } }
      }
    }
  end

  # ── Issue #111: Visualização dos templates criados ────────────────────────────

  describe 'GET /templates (#111)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'exibe a lista de templates cadastrados' do
        get '/templates'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(template_path(template))
      end

      it 'exibe botão para criar novo template' do
        get '/templates'

        expect(response.body).to include('Novo Template')
      end

      it 'exibe mensagem de estado vazio quando não há templates' do
        template.avaliacoes.destroy_all
        template.destroy!
        get '/templates'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Nenhum template encontrado')
      end
    end

    context 'usuário comum' do
      it 'redireciona para o dashboard' do
        sign_in aluno
        get '/templates'

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'não autenticado' do
      it 'redireciona para login' do
        get '/templates'
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'GET /templates/:id (#111)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'exibe o template com suas questões' do
        get "/templates/#{template.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Avaliação de Turma')
        expect(response.body).to include('Avalie a didática do professor')
      end
    end
  end

  # ── Issue #102: Criar template de formulário ─────────────────────────────────

  describe 'GET /templates/new (#102)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'exibe o formulário de criação' do
        get '/templates/new'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Novo Template')
        expect(response.body).to include('Título')
        expect(response.body).to include('Questões')
      end
    end

    context 'usuário comum' do
      it 'redireciona para o dashboard' do
        sign_in aluno
        get '/templates/new'

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe 'POST /templates (#102)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'cria o template com questões e redireciona (Caminho Feliz)' do
        expect {
          post '/templates', params: params_validos
        }.to change(Template, :count).by(1)
          .and change(Questao, :count).by(1)

        expect(response).to redirect_to(templates_path)
        expect(flash[:notice]).to include('Template criado com sucesso')
      end

      it 'falha ao criar template sem questões (Caminho Triste)' do
        params = { template: { titulo: 'Sem Questões', questoes_attributes: {} } }

        expect {
          post '/templates', params: params
        }.not_to change(Template, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('no mínimo uma questão')
      end

      it 'falha ao criar template sem título (Caminho Triste)' do
        params = params_validos.deep_merge(template: { titulo: '' })

        expect {
          post '/templates', params: params
        }.not_to change(Template, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'usuário comum' do
      it 'não cria template e redireciona' do
        sign_in aluno

        expect {
          post '/templates', params: params_validos
        }.not_to change(Template, :count)

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  # ── Issue #112: Edição e deleção de templates ────────────────────────────────

  describe 'GET /templates/:id/edit (#112)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'exibe o formulário de edição com os dados atuais' do
        get "/templates/#{template.id}/edit"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Avaliação de Turma')
        expect(response.body).to include('Avalie a didática do professor')
      end
    end
  end

  describe 'PATCH /templates/:id (#112)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'atualiza o título do template com sucesso (Caminho Feliz)' do
        patch "/templates/#{template.id}",
              params: { template: { titulo: 'Avaliação Atualizada',
                                    questoes_attributes: { '0' => { id: template.questoes.first.id,
                                                                     enunciado: 'Avalie a didática do professor' } } } }

        expect(response).to redirect_to(templates_path)
        expect(flash[:notice]).to include('Template atualizado com sucesso')
        expect(template.reload.titulo).to eq('Avaliação Atualizada')
      end

      it 'falha ao remover todas as questões do template (Caminho Triste)' do
        questao = template.questoes.first
        patch "/templates/#{template.id}",
              params: { template: { titulo: 'Avaliação de Turma',
                                    questoes_attributes: { '0' => { id: questao.id, _destroy: '1' } } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('no mínimo uma questão')
        expect(template.questoes.reload).not_to be_empty
      end
    end
  end

  describe 'DELETE /templates/:id (#112)' do
    context 'admin autenticado' do
      before { sign_in admin }

      it 'exclui template sem uso (Caminho Feliz)' do
        expect {
          delete "/templates/#{template.id}"
        }.to change(Template, :count).by(-1)

        expect(response).to redirect_to(templates_path)
        expect(flash[:notice]).to include('Template removido')
      end

      it 'não exclui template vinculado a avaliação ativa (Caminho Triste)' do
        disciplina = Disciplina.create!(codigo: 'CIC0097', nome: 'Banco de Dados', department: 'CIC')
        turma = Turma.create!(disciplina: disciplina, codigo: 'TA', semestre: '2026.1', horario: '35T45')
        Avaliacao.create!(template: template, turma: turma, tipo: 'discente',
                          data_inicio: Date.today, data_fim: Date.tomorrow)

        expect {
          delete "/templates/#{template.id}"
        }.not_to change(Template, :count)

        expect(response).to redirect_to(templates_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'usuário comum' do
      it 'não exclui e redireciona' do
        sign_in aluno

        expect {
          delete "/templates/#{template.id}"
        }.not_to change(Template, :count)

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
