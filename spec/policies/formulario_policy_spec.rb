require 'rails_helper'

RSpec.describe FormularioPolicy do
  let(:formulario) { create(:formulario) }
  let(:admin_user) { create(:user, role: 'admin') }
  let(:coordenador_user) { create(:user, role: 'coordenador') }
  let(:professor_user) { create(:user, role: 'professor') }
  let(:aluno_user) { create(:user, role: 'aluno') }

  describe 'permissions for admin' do
    subject { described_class.new(admin_user, formulario) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'permits create' do
      expect(subject).to be_create
    end

    it 'permits update' do
      expect(subject).to be_update
    end

    it 'permits destroy' do
      expect(subject).to be_destroy
    end
  end

  describe 'permissions for coordenador' do
    subject { described_class.new(coordenador_user, formulario) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'permits create' do
      expect(subject).to be_create
    end

    it 'permits update' do
      expect(subject).to be_update
    end

    it 'permits destroy' do
      expect(subject).to be_destroy
    end
  end

  describe 'permissions for professor' do
    subject { described_class.new(professor_user, formulario) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe 'permissions for aluno' do
    subject { described_class.new(aluno_user, formulario) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe 'permissions for nil user' do
    subject { described_class.new(nil, formulario) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'denies create' do
      expect(subject).not_to be_create
    end

    it 'denies update' do
      expect(subject).not_to be_update
    end

    it 'denies destroy' do
      expect(subject).not_to be_destroy
    end
  end
end
