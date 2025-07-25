# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:professor_user) { create(:user, :professor) }
  let(:aluno_user) { create(:user, :aluno) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET #index' do
    context 'when user is admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(admin_user).to receive(:professor?).and_return(false)
        allow(admin_user).to receive(:admin?).and_return(true)
      end

      it 'returns http success' do
        allow(Formulario).to receive(:all).and_return(Formulario.none)
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_gerais).and_return({
          total_formularios: 0, total_respostas: 0, formularios_com_respostas: 0, taxa_participacao: 0
        })
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'assigns all formularios for admin' do
        formularios = Formulario.none
        allow(Formulario).to receive(:all).and_return(formularios)
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_gerais).and_return({})
        get :index
        expect(assigns(:formularios)).to eq(formularios)
      end
    end

    context 'when user is professor' do
      before do
        allow(controller).to receive(:current_user).and_return(professor_user)
        allow(professor_user).to receive(:professor?).and_return(true)
        allow(professor_user).to receive(:admin?).and_return(false)
      end

      it 'returns http success' do
        allow_any_instance_of(ReportsController).to receive(:formularios_do_professor).and_return(Formulario.none)
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_gerais).and_return({
          total_formularios: 0, total_respostas: 0, formularios_com_respostas: 0, taxa_participacao: 0
        })
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is student' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
        allow(aluno_user).to receive(:professor?).and_return(false)
        allow(aluno_user).to receive(:admin?).and_return(false)
      end

      it 'redirects to root path with alert' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso negado. Apenas professores e administradores podem ver relatórios.')
      end
    end
  end

  describe 'GET #show' do
    let(:formulario_id) { '1' }

    context 'when user is admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(admin_user).to receive(:professor?).and_return(false)
        allow(admin_user).to receive(:admin?).and_return(true)
      end

      it 'returns http success' do
        formulario_mock = double('formulario')
        allow(Formulario).to receive(:find).with(formulario_id).and_return(formulario_mock)
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_formulario).and_return({})
        allow_any_instance_of(ReportsController).to receive(:obter_respostas_formulario).and_return({})
        
        get :show, params: { id: formulario_id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is professor' do
      before do
        allow(controller).to receive(:current_user).and_return(professor_user)
        allow(professor_user).to receive(:professor?).and_return(true)
        allow(professor_user).to receive(:admin?).and_return(false)
      end

      it 'returns http success' do
        disciplinas_relation = double('disciplinas_relation')
        allow(professor_user).to receive(:disciplinas_como_professor).and_return(disciplinas_relation)
        allow(disciplinas_relation).to receive(:pluck).with(:id).and_return([1])
        
        formularios_relation = double('formularios_relation')
        allow(Formulario).to receive(:where).with(disciplina_id: [1]).and_return(formularios_relation)
        
        formulario_mock = double('formulario')
        allow(formularios_relation).to receive(:find).with(formulario_id).and_return(formulario_mock)
        
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_formulario).and_return({})
        allow_any_instance_of(ReportsController).to receive(:obter_respostas_formulario).and_return({})
        
        get :show, params: { id: formulario_id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is student' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
        allow(aluno_user).to receive(:professor?).and_return(false)
        allow(aluno_user).to receive(:admin?).and_return(false)
      end

      it 'redirects to root path with alert' do
        get :show, params: { id: formulario_id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso negado. Apenas professores e administradores podem ver relatórios.')
      end
    end
  end

  describe 'authorization methods' do
    describe '#ensure_professor_or_admin!' do
      context 'when user is admin' do
        before do
          allow(controller).to receive(:current_user).and_return(admin_user)
          allow(admin_user).to receive(:professor?).and_return(false)
          allow(admin_user).to receive(:admin?).and_return(true)
        end

        it 'allows access' do
          allow(Formulario).to receive(:all).and_return(Formulario.none)
          allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_gerais).and_return({})
          get :index
          expect(response).not_to redirect_to(root_path)
        end
      end

      context 'when user is professor' do
        before do
          allow(controller).to receive(:current_user).and_return(professor_user)
          allow(professor_user).to receive(:professor?).and_return(true)
          allow(professor_user).to receive(:admin?).and_return(false)
        end

        it 'allows access' do
          allow_any_instance_of(ReportsController).to receive(:formularios_do_professor).and_return(Formulario.none)
          allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_gerais).and_return({})
          get :index
          expect(response).not_to redirect_to(root_path)
        end
      end

      context 'when user is student' do
        before do
          allow(controller).to receive(:current_user).and_return(aluno_user)
          allow(aluno_user).to receive(:professor?).and_return(false)
          allow(aluno_user).to receive(:admin?).and_return(false)
        end

        it 'denies access' do
          get :index
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Acesso negado. Apenas professores e administradores podem ver relatórios.')
        end
      end
    end

    describe 'private method coverage' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(admin_user).to receive(:professor?).and_return(false)
        allow(admin_user).to receive(:admin?).and_return(true)
      end

      it 'covers formularios_do_professor method' do
        allow(controller).to receive(:current_user).and_return(professor_user)
        allow(professor_user).to receive(:professor?).and_return(true)
        allow(professor_user).to receive(:admin?).and_return(false)
        
        disciplinas_relation = double('disciplinas_relation')
        allow(professor_user).to receive(:disciplinas_como_professor).and_return(disciplinas_relation)
        allow(disciplinas_relation).to receive(:pluck).with(:id).and_return([1])
        allow(Formulario).to receive(:where).with(disciplina_id: [1]).and_return(Formulario.none)
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_gerais).and_return({})
        
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'covers calcular_estatisticas_gerais method' do
        formularios = Formulario.none
        allow(Formulario).to receive(:all).and_return(formularios)
        
        # Mock the statistics calculation to avoid database calls
        allow(SubmissaoConcluida).to receive_message_chain(:joins, :where, :count).and_return(0)
        allow(formularios).to receive_message_chain(:joins, :distinct, :count).and_return(0)
        
        get :index
        expect(assigns(:estatisticas_gerais)).to be_present
        expect(response).to have_http_status(:success)
      end

      it 'covers calcular_estatisticas_formulario method' do
        formulario_mock = double('formulario')
        template_mock = double('template')
        submissoes_mock = double('submissoes')
        perguntas_mock = double('perguntas')
        
        allow(Formulario).to receive(:find).with('1').and_return(formulario_mock)
        allow(formulario_mock).to receive(:submissoes_concluidas).and_return(submissoes_mock)
        allow(submissoes_mock).to receive(:count).and_return(5)
        allow(formulario_mock).to receive(:template).and_return(template_mock)
        allow(template_mock).to receive(:pergunta).and_return(perguntas_mock)
        allow(perguntas_mock).to receive(:count).and_return(3)
        
        allow_any_instance_of(ReportsController).to receive(:obter_respostas_formulario).and_return({})
        
        get :show, params: { id: '1' }
        expect(assigns(:estatisticas)).to be_present
        expect(response).to have_http_status(:success)
      end

      it 'covers obter_respostas_formulario method' do
        formulario_mock = double('formulario')
        template_mock = double('template')
        pergunta_mock = double('pergunta', id: 1)
        
        allow(Formulario).to receive(:find).with('1').and_return(formulario_mock)
        allow(formulario_mock).to receive(:template).and_return(template_mock)
        allow(template_mock).to receive(:pergunta).and_return([pergunta_mock])
        
        allow(pergunta_mock).to receive(:multipla_escolha?).and_return(false)
        allow(pergunta_mock).to receive(:verdadeiro_falso?).and_return(false)
        allow(Respostum).to receive(:where).and_return(double(pluck: ['resposta1', 'resposta2']))
        
        allow_any_instance_of(ReportsController).to receive(:calcular_estatisticas_formulario).and_return({})
        
        get :show, params: { id: '1' }
        expect(assigns(:respostas)).to be_present
        expect(response).to have_http_status(:success)
      end

      it 'covers tempo medio calculation branch' do
        formulario_mock = double('formulario')
        allow(Formulario).to receive(:find).with('1').and_return(formulario_mock)
        allow(formulario_mock).to receive_message_chain(:submissoes_concluidas, :count).and_return(0)
        allow(formulario_mock).to receive_message_chain(:template, :pergunta, :count).and_return(1)
        allow_any_instance_of(ReportsController).to receive(:obter_respostas_formulario).and_return({})
        
        get :show, params: { id: '1' }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
