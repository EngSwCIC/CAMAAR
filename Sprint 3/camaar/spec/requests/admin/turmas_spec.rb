require 'rails_helper'

RSpec.describe 'Admin::Turmas', type: :request do
  let!(:admin_cic) do
    User.create!(name: 'Admin CIC', email: 'admin@cic.unb.br', password: 'senha123', role: 'admin', department: 'CIC')
  end

  let!(:admin_mat) do
    User.create!(name: 'Admin MAT', email: 'admin@mat.unb.br', password: 'senha123', role: 'admin', department: 'MAT')
  end

  let!(:disciplina_cic) do
    Disciplina.create!(codigo: 'CIC0097', nome: 'BANCOS DE DADOS', department: 'CIC')
  end

  let!(:disciplina_mat) do
    Disciplina.create!(codigo: 'MAT0001', nome: 'CÁLCULO 1', department: 'MAT')
  end

  let!(:turma_cic) do
    Turma.create!(disciplina: disciplina_cic, codigo: 'TA', semestre: '2021.2', horario: '35T45')
  end

  let!(:turma_mat) do
    Turma.create!(disciplina: disciplina_mat, codigo: 'TA', semestre: '2021.2', horario: '24M12')
  end

  describe 'GET /admin/turmas' do
    context 'Caminho Feliz - admin autenticado' do
      it 'retorna somente as turmas do departamento do admin CIC' do
        sign_in admin_cic
        get '/admin/turmas'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('BANCOS DE DADOS')
        expect(response.body).not_to include('CÁLCULO 1')
      end

      it 'retorna somente as turmas do departamento do admin MAT' do
        sign_in admin_mat
        get '/admin/turmas'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('CÁLCULO 1')
        expect(response.body).not_to include('BANCOS DE DADOS')
      end

      it 'exibe mensagem quando não há turmas no departamento' do
        admin_sem_turmas = User.create!(
          name: 'Admin Vazio', email: 'admin@vazio.unb.br',
          password: 'senha123', role: 'admin', department: 'FIS'
        )
        sign_in admin_sem_turmas
        get '/admin/turmas'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Nenhuma turma encontrada')
      end
    end

    context 'Caminho Triste - sem permissão' do
      it 'rejeita usuário não autenticado' do
        get '/admin/turmas'
        expect(response).to have_http_status(:redirect)
      end

      it 'rejeita usuário comum' do
        user = User.create!(name: 'Aluno', email: 'aluno@unb.br', password: 'senha123', role: 'user')
        sign_in user
        get '/admin/turmas'

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end