# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CursoPolicy, type: :policy do
  subject { described_class.new(user, curso) }

  let(:curso) { create(:curso) }

  context 'when user is admin' do
    let(:user) { create(:user, role: :admin) }

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

  context 'when user is coordenador' do
    let(:user) { create(:user, role: :coordenador) }

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

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  context 'when user is professor' do
    let(:user) { create(:user, role: :professor) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'does not permit create' do
      expect(subject).not_to be_create
    end

    it 'does not permit update' do
      expect(subject).not_to be_update
    end

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  context 'when user is aluno' do
    let(:user) { create(:user, role: :aluno) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'does not permit create' do
      expect(subject).not_to be_create
    end

    it 'does not permit update' do
      expect(subject).not_to be_update
    end

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  context 'when user is nil' do
    let(:user) { nil }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits show' do
      expect(subject).to be_show
    end

    it 'does not permit create' do
      expect(subject).not_to be_create
    end

    it 'does not permit update' do
      expect(subject).not_to be_update
    end

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  describe 'Scope' do
    let(:admin) { create(:user, role: :admin) }
    let(:professor) { create(:user, role: :professor) }
    let!(:curso1) { create(:curso, nome: 'Curso 1') }
    let!(:curso2) { create(:curso, nome: 'Curso 2') }

    it 'returns all cursos for any user' do
      scope = described_class::Scope.new(admin, Curso.all).resolve
      expect(scope).to include(curso1, curso2)
    end

    it 'returns all cursos for professor' do
      scope = described_class::Scope.new(professor, Curso.all).resolve
      expect(scope).to include(curso1, curso2)
    end
  end
end
