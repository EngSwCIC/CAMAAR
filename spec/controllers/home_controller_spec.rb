require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'in test environment' do
      before do
        allow(Rails.env).to receive(:test?).and_return(true)
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'assigns @current_user when no current_user' do
        allow(controller).to receive(:current_user).and_return(nil)
        get :index
        expect(assigns(:current_user)).to be_present
        expect(assigns(:current_user).name).to eq('Test User')
        expect(assigns(:current_user).role).to eq('admin')
      end

      it 'assigns @current_user when current_user exists' do
        user = create(:user, name: 'Real User', role: 'professor')
        allow(controller).to receive(:current_user).and_return(user)
        get :index
        expect(assigns(:current_user)).to eq(user)
      end

      it 'skips authentication' do
        expect(controller).not_to receive(:authenticate_user!)
        get :index
      end

      it 'returns early in test environment' do
        allow(controller).to receive(:current_user).and_return(create(:user, role: 'admin'))
        expect(controller).not_to receive(:redirect_to)
        get :index
        expect(response).to be_successful
      end
    end

    context 'in non-test environment' do
      let(:admin_user) { create(:user, role: 'admin') }
      let(:non_admin_user) { create(:user, role: 'aluno') }

      before do
        allow(Rails.env).to receive(:test?).and_return(false)
        allow(controller).to receive(:authenticate_user!).and_return(true)
      end

      context 'when user is admin' do
        before do
          allow(controller).to receive(:current_user).and_return(admin_user)
        end

        context 'when no imported data exists' do
          before do
            User.destroy_all
            Disciplina.destroy_all
            create(:user, email: 'admin@camaar.com')
            create(:user, email: 'coordenador@camaar.com')
            admin_user.save!
          end

          it 'redirects to admin management page' do
            get :index
            expect(response).to redirect_to(admin_management_path)
            expect(flash[:notice]).to eq('Para começar, importe os dados do SIGAA.')
          end
        end

        context 'when users exist but no disciplines' do
          before do
            User.destroy_all
            Disciplina.destroy_all
            create(:user, email: 'admin@camaar.com')
            create(:user, email: 'imported_user@example.com')
            admin_user.save!
          end

          it 'redirects to admin management page' do
            get :index
            expect(response).to redirect_to(admin_management_path)
            expect(flash[:notice]).to eq('Para começar, importe os dados do SIGAA.')
          end
        end

        context 'when disciplines exist but no imported users' do
          before do
            User.destroy_all
            Disciplina.destroy_all
            create(:user, email: 'admin@camaar.com')
            create(:disciplina)
            admin_user.save!
          end

          it 'redirects to admin management page' do
            get :index
            expect(response).to redirect_to(admin_management_path)
            expect(flash[:notice]).to eq('Para começar, importe os dados do SIGAA.')
          end
        end

        context 'when both users and disciplines exist' do
          before do
            User.destroy_all
            Disciplina.destroy_all
            create(:user, email: 'admin@camaar.com')
            create(:user, email: 'imported_user@example.com')
            create(:disciplina)
            admin_user.save!
          end

          it 'does not redirect' do
            get :index
            expect(response).to be_successful
            expect(response).not_to redirect_to(admin_management_path)
          end
        end

        context 'filtering seed emails' do
          before do
            User.destroy_all
            Disciplina.destroy_all
            # Create all seed users
            create(:user, email: 'admin@camaar.com')
            create(:user, email: 'coordenador@camaar.com')
            create(:user, email: 'professor@camaar.com')
            create(:user, email: 'aluno@camaar.com')
            admin_user.save!
          end

          it 'correctly filters out seed emails' do
            get :index
            expect(response).to redirect_to(admin_management_path)
          end
        end
      end

      context 'when user is not admin' do
        before do
          allow(controller).to receive(:current_user).and_return(non_admin_user)
          create(:user, email: 'imported_user@example.com')
          create(:disciplina)
        end

        it 'does not redirect regardless of data state' do
          get :index
          expect(response).to be_successful
          expect(response).not_to redirect_to(admin_management_path)
        end

        it 'assigns @current_user' do
          get :index
          expect(assigns(:current_user)).to eq(non_admin_user)
        end
      end

      context 'when no current_user' do
        before do
          allow(controller).to receive(:current_user).and_return(nil)
        end

        it 'assigns fallback @current_user and does not redirect' do
          get :index
          expect(assigns(:current_user)).to be_present
          expect(assigns(:current_user).name).to eq('Test User')
          expect(response).to be_successful
        end
      end
    end

    context 'authentication' do
      context 'in test environment' do
        before do
          allow(Rails.env).to receive(:test?).and_return(true)
        end

        it 'skips authentication' do
          expect(controller).not_to receive(:authenticate_user!)
          get :index
        end
      end

      context 'in non-test environment' do
        before do
          allow(Rails.env).to receive(:test?).and_return(false)
        end

        it 'requires authentication' do
          expect(controller).to receive(:authenticate_user!).and_return(true)
          get :index
        end
      end
    end
  end
end
