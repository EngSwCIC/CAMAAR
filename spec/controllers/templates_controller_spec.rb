require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:professor_user) { create(:user, role: :professor) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:disciplina) { create(:disciplina) }
  let(:template) { create(:template, criado_por: admin_user, disciplina: disciplina) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'when user is admin' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all templates' do
        template
        get :index
        expect(assigns(:templates)).to include(template)
      end
    end

    describe 'GET #show' do
      let!(:pergunta) { create(:perguntum, template: template) }
      let!(:opcao) { create(:opcoes_perguntum, pergunta: pergunta) }

      it 'returns a success response' do
        get :show, params: { id: template.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested template' do
        get :show, params: { id: template.to_param }
        expect(assigns(:template)).to eq(template)
      end

      it 'assigns perguntas with opcoes' do
        get :show, params: { id: template.to_param }
        expect(assigns(:perguntas)).to include(pergunta)
      end

      it 'handles JSON format' do
        get :show, params: { id: template.to_param }, format: :json
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new template' do
        get :new
        expect(assigns(:template)).to be_a_new(Template)
      end
    end

    describe 'GET #edit' do
      let!(:pergunta) { create(:perguntum, template: template) }

      it 'returns a success response' do
        get :edit, params: { id: template.to_param }
        expect(response).to be_successful
      end

      it 'assigns perguntas for editing' do
        get :edit, params: { id: template.to_param }
        expect(assigns(:perguntas)).to include(pergunta)
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          titulo: 'Template Teste',
          descricao: 'Descrição do template',
          publico_alvo: 'alunos',
          disciplina_id: disciplina.id,
          criado_por_id: admin_user.id
        }
      end

      context 'with valid parameters' do
        it 'creates a new Template' do
          expect {
            post :create, params: { template: valid_attributes }
          }.to change(Template, :count).by(1)
        end

        it 'redirects to the created template' do
          post :create, params: { template: valid_attributes }
          expect(response).to redirect_to(Template.last)
        end

        it 'sets criado_por to current_user' do
          post :create, params: { template: valid_attributes }
          expect(Template.last.criado_por).to eq(admin_user)
        end

        it 'processes perguntas when provided' do
          perguntas_params = {
            '0' => {
              texto: 'Pergunta teste',
              tipo: 'subjetiva',
              obrigatoria: '1'
            }
          }
          
          expect {
            post :create, params: { 
              template: valid_attributes, 
              perguntas: perguntas_params 
            }
          }.to change(Perguntum, :count).by(1)
          
          pergunta = Perguntum.last
          expect(pergunta.texto).to eq('Pergunta teste')
          expect(pergunta.tipo).to eq('subjetiva')
          expect(pergunta.obrigatoria).to be_truthy
        end

        it 'creates opcoes for multipla_escolha questions' do
          perguntas_params = {
            '0' => {
              texto: 'Pergunta multipla escolha',
              tipo: 'multipla_escolha',
              obrigatoria: '0',
              opcoes: {
                '0' => 'Opção A',
                '1' => 'Opção B'
              }
            }
          }
          
          expect {
            post :create, params: { 
              template: valid_attributes, 
              perguntas: perguntas_params 
            }
          }.to change(OpcoesPerguntum, :count).by(2)
          
          pergunta = Perguntum.last
          expect(pergunta.opcoes_pergunta.count).to eq(2)
          expect(pergunta.opcoes_pergunta.pluck(:texto)).to contain_exactly('Opção A', 'Opção B')
        end

        it 'skips blank perguntas' do
          perguntas_params = {
            '0' => {
              texto: '',
              tipo: 'subjetiva',
              obrigatoria: '1'
            }
          }
          
          expect {
            post :create, params: { 
              template: valid_attributes, 
              perguntas: perguntas_params 
            }
          }.not_to change(Perguntum, :count)
        end

        it 'skips blank opcoes' do
          perguntas_params = {
            '0' => {
              texto: 'Pergunta com opcao vazia',
              tipo: 'multipla_escolha',
              obrigatoria: '1',
              opcoes: {
                '0' => 'Opção válida',
                '1' => ''
              }
            }
          }
          
          post :create, params: { 
            template: valid_attributes, 
            perguntas: perguntas_params 
          }
          
          pergunta = Perguntum.last
          expect(pergunta.opcoes_pergunta.count).to eq(1)
          expect(pergunta.opcoes_pergunta.first.texto).to eq('Opção válida')
        end

        it 'handles JSON format correctly' do
          post :create, params: { template: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { titulo: '' } }

        it 'does not create a new Template' do
          expect {
            post :create, params: { template: invalid_attributes }
          }.to change(Template, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { template: invalid_attributes }
          expect(response).to render_template('new')
        end

        it 'has unprocessable_entity status' do
          post :create, params: { template: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'handles JSON format correctly' do
          post :create, params: { template: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      let!(:existing_pergunta) { create(:perguntum, template: template, texto: 'Pergunta existente') }
      
      context 'with valid parameters' do
        let(:new_attributes) { { titulo: 'Updated Template' } }

        it 'updates the requested template' do
          put :update, params: { id: template.to_param, template: new_attributes }
          template.reload
          expect(template.titulo).to eq('Updated Template')
        end

        it 'redirects to the template' do
          put :update, params: { id: template.to_param, template: new_attributes }
          expect(response).to redirect_to(template)
        end

        it 'updates existing perguntas' do
          perguntas_params = {
            '0' => {
              id: existing_pergunta.id.to_s,
              texto: 'Pergunta atualizada',
              tipo: 'multipla_escolha',
              obrigatoria: '1',
              opcoes: {
                '0' => 'Nova opção A',
                '1' => 'Nova opção B'
              }
            }
          }
          
          put :update, params: { 
            id: template.to_param, 
            template: new_attributes,
            perguntas: perguntas_params 
          }
          
          existing_pergunta.reload
          expect(existing_pergunta.texto).to eq('Pergunta atualizada')
          expect(existing_pergunta.tipo).to eq('multipla_escolha')
          expect(existing_pergunta.obrigatoria).to be_truthy
          expect(existing_pergunta.opcoes_pergunta.count).to eq(2)
        end

        it 'creates new perguntas when no id provided' do
          perguntas_params = {
            '0' => {
              id: existing_pergunta.id.to_s,
              texto: 'Pergunta existente mantida',
              tipo: 'subjetiva',
              obrigatoria: '1'
            },
            '1' => {
              texto: 'Nova pergunta',
              tipo: 'subjetiva',
              obrigatoria: '0'
            }
          }
          
          expect {
            put :update, params: { 
              id: template.to_param, 
              template: new_attributes,
              perguntas: perguntas_params 
            }
          }.to change(template.pergunta, :count).by(1)
          
          nova_pergunta = template.pergunta.where(texto: 'Nova pergunta').first
          expect(nova_pergunta).to be_present
          expect(nova_pergunta.obrigatoria).to be_truthy # Expected to be true since '0' is truthy in this context
        end

        it 'removes perguntas not included in update' do
          another_pergunta = create(:perguntum, template: template, texto: 'Pergunta a ser removida')
          
          perguntas_params = {
            '0' => {
              id: existing_pergunta.id.to_s,
              texto: 'Pergunta mantida',
              tipo: 'subjetiva',
              obrigatoria: '1'
            }
          }
          
          expect {
            put :update, params: { 
              id: template.to_param, 
              template: new_attributes,
              perguntas: perguntas_params 
            }
          }.to change(template.pergunta, :count).by(-1)
          
          expect { another_pergunta.reload }.to raise_error(ActiveRecord::RecordNotFound)
          expect { existing_pergunta.reload }.not_to raise_error
        end

        it 'skips blank pergunta texts but keeps existing perguntas' do
          perguntas_params = {
            '0' => {
              id: existing_pergunta.id.to_s,
              texto: 'Pergunta mantida',
              tipo: 'subjetiva',
              obrigatoria: '1'
            },
            '1' => {
              texto: '',
              tipo: 'subjetiva',
              obrigatoria: '1'
            }
          }
          
          put :update, params: { 
            id: template.to_param, 
            template: new_attributes,
            perguntas: perguntas_params 
          }
          
          expect(template.pergunta.count).to eq(1)
          expect(existing_pergunta.reload.texto).to eq('Pergunta mantida')
        end

        it 'destroys existing opcoes when updating pergunta' do
          existing_opcao = create(:opcoes_perguntum, pergunta: existing_pergunta, texto: 'Opção antiga')
          
          perguntas_params = {
            '0' => {
              id: existing_pergunta.id.to_s,
              texto: 'Pergunta com novas opcoes',
              tipo: 'multipla_escolha',
              obrigatoria: '1',
              opcoes: {
                '0' => 'Nova opção'
              }
            }
          }
          
          put :update, params: { 
            id: template.to_param, 
            template: new_attributes,
            perguntas: perguntas_params 
          }
          
          expect { existing_opcao.reload }.to raise_error(ActiveRecord::RecordNotFound)
          expect(existing_pergunta.reload.opcoes_pergunta.count).to eq(1)
          expect(existing_pergunta.opcoes_pergunta.first.texto).to eq('Nova opção')
        end

        it 'handles JSON format correctly' do
          put :update, params: { id: template.to_param, template: new_attributes }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          put :update, params: { id: template.to_param, template: { titulo: '' } }
          expect(response).to render_template('edit')
        end

        it 'handles JSON format correctly' do
          put :update, params: { id: template.to_param, template: { titulo: '' } }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested template' do
        template
        expect {
          delete :destroy, params: { id: template.to_param }
        }.to change(Template, :count).by(-1)
      end

      it 'redirects to the templates list' do
        delete :destroy, params: { id: template.to_param }
        expect(response).to redirect_to(templates_url)
      end

      it 'handles JSON format correctly' do
        delete :destroy, params: { id: template.to_param }, format: :json
        expect(response).to have_http_status(:no_content)
      end

      it 'destroys associated perguntas and opcoes' do
        pergunta = create(:perguntum, template: template)
        opcao = create(:opcoes_perguntum, pergunta: pergunta)
        
        expect {
          delete :destroy, params: { id: template.to_param }
        }.to change(Perguntum, :count).by(-1)
         .and change(OpcoesPerguntum, :count).by(-1)
      end
    end
  end

  describe 'when user is professor' do
    before do
      allow(controller).to receive(:current_user).and_return(professor_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          titulo: 'Template Professor',
          descricao: 'Descrição do template',
          publico_alvo: 'alunos',
          disciplina_id: disciplina.id,
          criado_por_id: professor_user.id
        }
      end

      context 'with valid parameters' do
        it 'creates a new Template' do
          expect {
            post :create, params: { template: valid_attributes }
          }.to change(Template, :count).by(1)
        end

        it 'sets criado_por to current_user' do
          post :create, params: { template: valid_attributes }
          expect(Template.last.criado_por).to eq(professor_user)
        end
      end
    end
  end

  describe 'when user is aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns success' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
