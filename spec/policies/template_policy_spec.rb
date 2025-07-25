require 'rails_helper'

RSpec.describe TemplatePolicy do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:coordenador_user) { create(:user, role: 'coordenador') }
  let(:professor_user) { create(:user, role: 'professor') }
  let(:aluno_user) { create(:user, role: 'aluno') }
  let(:template) { create(:template, criado_por: admin_user) }

  describe 'permissions for admin' do
    subject { described_class.new(admin_user, template) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'permits new' do
      expect(subject).to be_new
    end

    it 'permits create' do
      expect(subject).to be_create
    end

    it 'permits edit' do
      expect(subject).to be_edit
    end

    it 'permits update' do
      expect(subject).to be_update
    end

    it 'permits destroy' do
      expect(subject).to be_destroy
    end
  end

  describe 'permissions for coordenador' do
    subject { described_class.new(coordenador_user, template) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies show' do
      expect(subject).not_to be_show
    end

    it 'denies new' do
      expect(subject).not_to be_new
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies edit' do
      expect(subject).not_to be_edit
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe 'permissions for professor' do
    subject { described_class.new(professor_user, template) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies show' do
      expect(subject).not_to be_show
    end

    it 'denies new' do
      expect(subject).not_to be_new
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies edit' do
      expect(subject).not_to be_edit
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe 'permissions for aluno' do
    subject { described_class.new(aluno_user, template) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies show' do
      expect(subject).not_to be_show
    end

    it 'denies new' do
      expect(subject).not_to be_new
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies edit' do
      expect(subject).not_to be_edit
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe 'permissions for nil user' do
    subject { described_class.new(nil, template) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies show' do
      expect(subject).not_to be_show
    end

    it 'denies new' do
      expect(subject).not_to be_new
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies edit' do
      expect(subject).not_to be_edit
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe TemplatePolicy::Scope do
    describe '#resolve' do
      let!(:template1) { create(:template, criado_por: admin_user) }
      let!(:template2) { create(:template, criado_por: admin_user) }
      let(:scope) { Template.all }

      context 'for admin user' do
        let(:resolved_scope) { described_class.new(admin_user, scope).resolve }

        it 'returns all templates' do
          expect(resolved_scope).to include(template1, template2)
          expect(resolved_scope.count).to eq(2)
        end
      end

      context 'for coordenador user' do
        let(:resolved_scope) { described_class.new(coordenador_user, scope).resolve }

        it 'returns no templates' do
          expect(resolved_scope).to be_empty
          expect(resolved_scope.count).to eq(0)
        end
      end

      context 'for professor user' do
        let(:resolved_scope) { described_class.new(professor_user, scope).resolve }

        it 'returns no templates' do
          expect(resolved_scope).to be_empty
          expect(resolved_scope.count).to eq(0)
        end
      end

      context 'for aluno user' do
        let(:resolved_scope) { described_class.new(aluno_user, scope).resolve }

        it 'returns no templates' do
          expect(resolved_scope).to be_empty
          expect(resolved_scope.count).to eq(0)
        end
      end

      context 'for nil user' do
        let(:resolved_scope) { described_class.new(nil, scope).resolve }

        it 'returns no templates' do
          expect(resolved_scope).to be_empty
          expect(resolved_scope.count).to eq(0)
        end
      end
    end
  end
end
