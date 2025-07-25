# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(current_user, target_user) }

  let(:target_user) { create(:user, role: :aluno) }

  context 'when current user is admin' do
    let(:current_user) { create(:user, role: :admin) }

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

    it 'permits destroy for other users' do
      expect(subject).to be_destroy
    end

    it 'does not permit destroy for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).not_to be_destroy
    end
  end

  context 'when current user is coordenador' do
    let(:current_user) { create(:user, role: :coordenador) }

    it 'does not permit index' do
      expect(subject).not_to be_index
    end

    it 'does not permit show for other users' do
      expect(subject).not_to be_show
    end

    it 'permits show for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).to be_show
    end

    it 'does not permit create' do
      expect(subject).not_to be_create
    end

    it 'does not permit update for other users' do
      expect(subject).not_to be_update
    end

    it 'permits update for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).to be_update
    end

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  context 'when current user is professor' do
    let(:current_user) { create(:user, role: :professor) }

    it 'does not permit index' do
      expect(subject).not_to be_index
    end

    it 'does not permit show for other users' do
      expect(subject).not_to be_show
    end

    it 'permits show for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).to be_show
    end

    it 'does not permit create' do
      expect(subject).not_to be_create
    end

    it 'does not permit update for other users' do
      expect(subject).not_to be_update
    end

    it 'permits update for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).to be_update
    end

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  context 'when current user is aluno' do
    let(:current_user) { create(:user, role: :aluno) }

    it 'does not permit index' do
      expect(subject).not_to be_index
    end

    it 'does not permit show for other users' do
      expect(subject).not_to be_show
    end

    it 'permits show for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).to be_show
    end

    it 'does not permit create' do
      expect(subject).not_to be_create
    end

    it 'does not permit update for other users' do
      expect(subject).not_to be_update
    end

    it 'permits update for self' do
      subject = described_class.new(current_user, current_user)
      expect(subject).to be_update
    end

    it 'does not permit destroy' do
      expect(subject).not_to be_destroy
    end
  end

  context 'when current user is nil' do
    let(:current_user) { nil }

    it 'does not permit index' do
      expect(subject).not_to be_index
    end

    it 'does not permit show' do
      expect(subject).not_to be_show
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
end
