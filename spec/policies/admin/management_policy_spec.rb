require 'rails_helper'

RSpec.describe Admin::ManagementPolicy do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:coordenador_user) { create(:user, role: 'coordenador') }
  let(:professor_user) { create(:user, role: 'professor') }
  let(:aluno_user) { create(:user, role: 'aluno') }

  describe 'permissions for admin' do
    subject { described_class.new(admin_user, nil) }

    it 'permits index' do
      expect(subject).to be_index
    end

    it 'permits import_users' do
      expect(subject).to be_import_users
    end

    it 'permits import_disciplines' do
      expect(subject).to be_import_disciplines
    end
  end

  describe 'permissions for coordenador' do
    subject { described_class.new(coordenador_user, nil) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies import_users' do
      expect(subject).not_to be_import_users
    end

    it 'denies import_disciplines' do
      expect(subject).not_to be_import_disciplines
    end
  end

  describe 'permissions for professor' do
    subject { described_class.new(professor_user, nil) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies import_users' do
      expect(subject).not_to be_import_users
    end

    it 'denies import_disciplines' do
      expect(subject).not_to be_import_disciplines
    end
  end

  describe 'permissions for aluno' do
    subject { described_class.new(aluno_user, nil) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies import_users' do
      expect(subject).not_to be_import_users
    end

    it 'denies import_disciplines' do
      expect(subject).not_to be_import_disciplines
    end
  end

  describe 'permissions for nil user' do
    subject { described_class.new(nil, nil) }

    it 'denies index' do
      expect(subject).not_to be_index
    end

    it 'denies import_users' do
      expect(subject).not_to be_import_users
    end

    it 'denies import_disciplines' do
      expect(subject).not_to be_import_disciplines
    end
  end

  describe Admin::ManagementPolicy::Scope do
    describe '#resolve' do
      let(:scope) { double('scope') }
      let(:all_scope) { double('all_scope') }
      let(:none_scope) { double('none_scope') }

      before do
        allow(scope).to receive(:all).and_return(all_scope)
        allow(scope).to receive(:none).and_return(none_scope)
      end

      context 'for admin user' do
        let(:resolved_scope) { described_class.new(admin_user, scope).resolve }

        it 'returns all scope' do
          expect(resolved_scope).to eq(all_scope)
        end
      end

      context 'for coordenador user' do
        let(:resolved_scope) { described_class.new(coordenador_user, scope).resolve }

        it 'returns none scope' do
          expect(resolved_scope).to eq(none_scope)
        end
      end

      context 'for professor user' do
        let(:resolved_scope) { described_class.new(professor_user, scope).resolve }

        it 'returns none scope' do
          expect(resolved_scope).to eq(none_scope)
        end
      end

      context 'for aluno user' do
        let(:resolved_scope) { described_class.new(aluno_user, scope).resolve }

        it 'returns none scope' do
          expect(resolved_scope).to eq(none_scope)
        end
      end

      context 'for nil user' do
        let(:resolved_scope) { described_class.new(nil, scope).resolve }

        it 'returns none scope' do
          expect(resolved_scope).to eq(none_scope)
        end
      end
    end
  end
end
