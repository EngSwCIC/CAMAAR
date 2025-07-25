# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  subject { described_class.new(user, record) }

  let(:record) { double('record') }

  context 'when user is admin' do
    let(:user) { create(:user, role: :admin) }

    it 'does not permit index by default' do
      expect(subject).not_to be_index
    end

    it 'does not permit show by default' do
      expect(subject).not_to be_show
    end

    it 'does not permit create by default' do
      expect(subject).not_to be_create
    end

    it 'does not permit update by default' do
      expect(subject).not_to be_update
    end

    it 'does not permit destroy by default' do
      expect(subject).not_to be_destroy
    end

    it 'new delegates to create' do
      allow(subject).to receive(:create?).and_return(true)
      expect(subject).to be_new
    end

    it 'edit delegates to update' do
      allow(subject).to receive(:update?).and_return(true)
      expect(subject).to be_edit
    end

    it 'returns true for admin_only' do
      expect(subject).to be_admin_only
    end

    it 'returns true for professor_and_above' do
      expect(subject).to be_professor_and_above
    end

    it 'returns true for coordenador_and_above' do
      expect(subject).to be_coordenador_and_above
    end
  end

  context 'when user is coordenador' do
    let(:user) { create(:user, role: :coordenador) }

    it 'returns false for admin_only' do
      expect(subject).not_to be_admin_only
    end

    it 'returns true for professor_and_above' do
      expect(subject).to be_professor_and_above
    end

    it 'returns true for coordenador_and_above' do
      expect(subject).to be_coordenador_and_above
    end
  end

  context 'when user is professor' do
    let(:user) { create(:user, role: :professor) }

    it 'returns false for admin_only' do
      expect(subject).not_to be_admin_only
    end

    it 'returns true for professor_and_above' do
      expect(subject).to be_professor_and_above
    end

    it 'returns false for coordenador_and_above' do
      expect(subject).not_to be_coordenador_and_above
    end
  end

  context 'when user is aluno' do
    let(:user) { create(:user, role: :aluno) }

    it 'returns false for admin_only' do
      expect(subject).not_to be_admin_only
    end

    it 'returns false for professor_and_above' do
      expect(subject).not_to be_professor_and_above
    end

    it 'returns false for coordenador_and_above' do
      expect(subject).not_to be_coordenador_and_above
    end
  end

  context 'when user is nil' do
    let(:user) { nil }

    it 'returns false for admin_only' do
      expect(subject).not_to be_admin_only
    end

    it 'returns false for professor_and_above' do
      expect(subject).not_to be_professor_and_above
    end

    it 'returns false for coordenador_and_above' do
      expect(subject).not_to be_coordenador_and_above
    end
  end

  describe 'Scope' do
    let(:user) { create(:user, role: :admin) }
    let(:scope) { double('scope') }

    it 'raises NotImplementedError for resolve' do
      scope_instance = described_class::Scope.new(user, scope)
      expect { scope_instance.resolve }.to raise_error(NotImplementedError)
    end

    it 'initializes with user and scope' do
      scope_instance = described_class::Scope.new(user, scope)
      expect(scope_instance.send(:user)).to eq(user)
      expect(scope_instance.send(:scope)).to eq(scope)
    end
  end
end
