# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Formulario, type: :model do
  let(:user) do
    User.create!(name: 'Test User', email: 'test@example.com', password: 'password', matricula: '12345', role: 'admin')
  end
  let(:curso) { Curso.create!(nome: 'Test Course') }
  let(:disciplina) { Disciplina.create!(nome: 'Test Discipline', curso: curso) }
  let(:professor) do
    User.create!(name: 'Professor', email: 'prof@example.com', password: 'password', matricula: '67890',
                 role: 'professor')
  end
  let(:turma) { Turma.create!(disciplina: disciplina, professor: professor, semestre: '2024.1') }
  let(:template) do
    Template.create!(titulo: 'Test Template', publico_alvo: 1, criado_por: user, disciplina: disciplina)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      formulario = described_class.new(
        template: template,
        turma: turma,
        coordenador: user,
        data_envio: Time.current,
        data_fim: 1.week.from_now
      )
      expect(formulario).to be_valid
    end

    it 'is invalid without a template' do
      formulario = described_class.new(turma: turma, coordenador: user, data_envio: Time.current, data_fim: 1.week.from_now)
      expect(formulario).not_to be_valid
      expect(formulario.errors[:template]).to include("must exist")
    end

    it 'is invalid without a coordenador' do
      formulario = described_class.new(template: template, turma: turma, data_envio: Time.current, data_fim: 1.week.from_now)
      expect(formulario).not_to be_valid
      expect(formulario.errors[:coordenador]).to include("must exist")
    end

    it 'is invalid without data_envio' do
      formulario = described_class.new(template: template, turma: turma, coordenador: user, data_fim: 1.week.from_now)
      expect(formulario).not_to be_valid
      expect(formulario.errors[:data_envio]).to include("can't be blank")
    end

    it 'is invalid without data_fim' do
      formulario = described_class.new(template: template, turma: turma, coordenador: user, data_envio: Time.current)
      expect(formulario).not_to be_valid
      expect(formulario.errors[:data_fim]).to include("can't be blank")
    end

    it 'is invalid when data_fim is before data_envio' do
      formulario = described_class.new(
        template: template,
        turma: turma,
        coordenador: user,
        data_envio: 1.week.from_now,
        data_fim: Time.current
      )
      expect(formulario).not_to be_valid
      expect(formulario.errors[:data_fim]).to include("must be greater than #{1.week.from_now}")
    end

    context 'when escopo_visibilidade is por_disciplina' do
      it 'requires disciplina_id' do
        formulario = described_class.new(
          template: template,
          turma: turma,
          coordenador: user,
          data_envio: Time.current,
          data_fim: 1.week.from_now,
          escopo_visibilidade: 'por_disciplina'
        )
        expect(formulario).not_to be_valid
        expect(formulario.errors[:disciplina_id]).to include("can't be blank")
      end

      it 'is valid with disciplina_id' do
        formulario = described_class.new(
          template: template,
          turma: turma,
          coordenador: user,
          data_envio: Time.current,
          data_fim: 1.week.from_now,
          escopo_visibilidade: 'por_disciplina',
          disciplina: disciplina
        )
        expect(formulario).to be_valid
      end
    end
  end

  describe 'associations' do
    let(:formulario) do
      described_class.create!(template: template, turma: turma, coordenador: user, data_envio: Time.current,
                              data_fim: 1.week.from_now)
    end

    it 'belongs to a template' do
      expect(formulario.template).to eq(template)
    end

    it 'belongs to a turma' do
      expect(formulario.turma).to eq(turma)
    end

    it 'belongs to a coordenador (user)' do
      expect(formulario.coordenador).to eq(user)
    end

    it 'can belong to a disciplina' do
      formulario.update!(disciplina: disciplina)
      expect(formulario.disciplina).to eq(disciplina)
    end

    it 'has many resposta' do
      expect(formulario).to respond_to(:resposta)
    end

    it 'has many submissoes_concluidas' do
      expect(formulario).to respond_to(:submissoes_concluidas)
    end
  end

  describe 'enums' do
    let(:formulario) { create(:formulario, template: template, coordenador: user) }

    it 'defines escopo_visibilidade enum' do
      expect(formulario).to respond_to(:todos_os_alunos?)
      expect(formulario).to respond_to(:por_turma?)
      expect(formulario).to respond_to(:por_disciplina?)
      expect(formulario).to respond_to(:por_curso?)
    end

    it 'sets default escopo_visibilidade to todos_os_alunos' do
      expect(formulario.todos_os_alunos?).to be true
    end
  end

  describe 'scopes' do
    let!(:formulario_ativo) { create(:formulario, ativo: true, template: template, coordenador: user) }
    let!(:formulario_inativo) { create(:formulario, ativo: false, template: template, coordenador: user) }
    let!(:formulario_passado) do
      create(:formulario, 
             data_envio: 2.weeks.ago, 
             data_fim: 1.week.ago, 
             template: template, 
             coordenador: user)
    end
    let!(:formulario_futuro) do
      create(:formulario, 
             data_envio: 1.week.from_now, 
             data_fim: 2.weeks.from_now, 
             template: template, 
             coordenador: user)
    end
    let!(:formulario_atual) do
      create(:formulario, 
             data_envio: 1.hour.ago, 
             data_fim: 1.week.from_now, 
             template: template, 
             coordenador: user)
    end

    describe '.ativos' do
      it 'returns only active formularios' do
        expect(Formulario.ativos).to include(formulario_ativo, formulario_atual)
        expect(Formulario.ativos).not_to include(formulario_inativo)
      end
    end

    describe '.no_periodo' do
      it 'returns only formularios in current period' do
        expect(Formulario.no_periodo).to include(formulario_atual)
        expect(Formulario.no_periodo).not_to include(formulario_passado, formulario_futuro)
      end
    end
  end

  describe 'delegate methods' do
    let(:formulario) { create(:formulario, template: template, coordenador: user) }

    it 'delegates publico_alvo to template' do
      expect(formulario.publico_alvo).to eq(template.publico_alvo)
    end
  end

  describe '#can_be_seen_by?' do
    let(:aluno) { create(:user, :aluno) }
    let(:professor_user) { create(:user, :professor) }
    let(:template_alunos) { create(:template, publico_alvo: 'alunos', criado_por: user) }
    let(:template_professores) { create(:template, publico_alvo: 'professores', criado_por: user) }

    context 'when formulario is inactive' do
      let(:formulario) do
        create(:formulario, ativo: false, template: template_alunos, coordenador: user)
      end

      it 'returns false' do
        expect(formulario.can_be_seen_by?(aluno)).to be false
      end
    end

    context 'when formulario is not in period' do
      let(:formulario) do
        create(:formulario, 
               data_envio: 2.weeks.ago, 
               data_fim: 1.week.ago, 
               template: template_alunos, 
               coordenador: user)
      end

      it 'returns false' do
        expect(formulario.can_be_seen_by?(aluno)).to be false
      end
    end

    context 'when formulario is for alunos' do
      let(:formulario) do
        create(:formulario, 
               ativo: true,
               data_envio: 1.hour.ago,
               data_fim: 1.week.from_now,
               template: template_alunos, 
               coordenador: user,
               escopo_visibilidade: 'todos_os_alunos')
      end

      it 'returns true for aluno user' do
        expect(formulario.can_be_seen_by?(aluno)).to be true
      end

      it 'returns false for professor user' do
        expect(formulario.can_be_seen_by?(professor_user)).to be false
      end
    end

    context 'when formulario is for professores' do
      let(:formulario) do
        create(:formulario, 
               ativo: true,
               data_envio: 1.hour.ago,
               data_fim: 1.week.from_now,
               template: template_professores, 
               coordenador: user,
               escopo_visibilidade: 'todos_os_alunos')
      end

      it 'returns true for professor user' do
        expect(formulario.can_be_seen_by?(professor_user)).to be true
      end

      it 'returns false for aluno user' do
        expect(formulario.can_be_seen_by?(aluno)).to be false
      end
    end

    context 'when template has coordenadores publico_alvo' do
      let(:template_coordenadores) { create(:template, publico_alvo: 'coordenadores', criado_por: user) }
      let(:formulario) do
        create(:formulario, 
               ativo: true,
               data_envio: 1.hour.ago,
               data_fim: 1.week.from_now,
               template: template_coordenadores, 
               coordenador: user)
      end

      it 'returns false for any user (coordenadores not handled in can_be_seen_by?)' do
        expect(formulario.can_be_seen_by?(aluno)).to be false
        expect(formulario.can_be_seen_by?(professor_user)).to be false
      end
    end

    context 'when escopo_visibilidade is por_disciplina' do
      let(:formulario) do
        create(:formulario, 
               ativo: true,
               data_envio: 1.hour.ago,
               data_fim: 1.week.from_now,
               template: template_alunos, 
               coordenador: user,
               escopo_visibilidade: 'por_disciplina',
               disciplina: disciplina)
      end

      it 'calls appropriate access method' do
        allow(aluno).to receive(:matriculado_em_disciplina?).with(disciplina.id).and_return(true)
        expect(formulario.can_be_seen_by?(aluno)).to be true
      end
    end
  end

  describe '#already_answered_by?' do
    let(:formulario) { create(:formulario, template: template, coordenador: user) }
    let(:aluno) { create(:user, :aluno) }

    context 'when user has not answered' do
      it 'returns false' do
        expect(formulario.already_answered_by?(aluno)).to be false
      end
    end

    context 'when user has answered' do
      before do
        create(:submissao_concluida, formulario: formulario, user: aluno)
      end

      it 'returns true' do
        expect(formulario.already_answered_by?(aluno)).to be true
      end
    end
  end

  describe '#respondido_por?' do
    let(:formulario) { create(:formulario, template: template, coordenador: user) }
    let(:aluno) { create(:user, :aluno) }

    it 'behaves the same as already_answered_by?' do
      expect(formulario.respondido_por?(aluno)).to eq(formulario.already_answered_by?(aluno))
      
      create(:submissao_concluida, formulario: formulario, user: aluno)
      expect(formulario.respondido_por?(aluno)).to eq(formulario.already_answered_by?(aluno))
    end
  end

  describe 'private methods' do
    let(:formulario) do
      create(:formulario, 
             ativo: true,
             data_envio: 1.hour.ago,
             data_fim: 1.week.from_now,
             template: template, 
             coordenador: user)
    end

    describe '#no_periodo?' do
      it 'returns true when current time is between data_envio and data_fim' do
        expect(formulario.send(:no_periodo?)).to be true
      end

      it 'returns false when current time is before data_envio' do
        formulario.update!(data_envio: 1.hour.from_now, data_fim: 2.hours.from_now)
        expect(formulario.send(:no_periodo?)).to be false
      end

      it 'returns false when current time is after data_fim' do
        formulario.update!(data_envio: 2.hours.ago, data_fim: 1.hour.ago)
        expect(formulario.send(:no_periodo?)).to be false
      end
    end

    describe '#visible_for_professor?' do
      let(:professor_user) { create(:user, :professor) }

      context 'when user is not a professor' do
        let(:aluno) { create(:user, :aluno) }

        it 'returns false' do
          expect(formulario.send(:visible_for_professor?, aluno)).to be false
        end
      end

      context 'when user is a professor and escopo is todos_os_alunos' do
        it 'returns true' do
          formulario.update!(escopo_visibilidade: 'todos_os_alunos')
          expect(formulario.send(:visible_for_professor?, professor_user)).to be true
        end
      end

      context 'when user is a professor and escopo is por_disciplina' do
        before do
          formulario.update!(escopo_visibilidade: 'por_disciplina', disciplina: disciplina)
        end

        it 'returns true when professor teaches the disciplina' do
          allow(professor_user).to receive(:leciona_disciplina?).with(disciplina.id).and_return(true)
          expect(formulario.send(:visible_for_professor?, professor_user)).to be true
        end

        it 'returns false when professor does not teach the disciplina' do
          allow(professor_user).to receive(:leciona_disciplina?).with(disciplina.id).and_return(false)
          expect(formulario.send(:visible_for_professor?, professor_user)).to be false
        end
      end
    end

    describe '#visible_for_aluno?' do
      let(:aluno) { create(:user, :aluno) }

      context 'when user is not an aluno' do
        let(:professor_user) { create(:user, :professor) }

        it 'returns false' do
          expect(formulario.send(:visible_for_aluno?, professor_user)).to be false
        end
      end

      context 'when user is an aluno and escopo is todos_os_alunos' do
        it 'returns true' do
          formulario.update!(escopo_visibilidade: 'todos_os_alunos')
          expect(formulario.send(:visible_for_aluno?, aluno)).to be true
        end
      end

      context 'when user is an aluno and escopo is por_disciplina' do
        before do
          formulario.update!(escopo_visibilidade: 'por_disciplina', disciplina: disciplina)
        end

        it 'returns true when aluno is enrolled in the disciplina' do
          allow(aluno).to receive(:matriculado_em_disciplina?).with(disciplina.id).and_return(true)
          expect(formulario.send(:visible_for_aluno?, aluno)).to be true
        end

        it 'returns false when aluno is not enrolled in the disciplina' do
          allow(aluno).to receive(:matriculado_em_disciplina?).with(disciplina.id).and_return(false)
          expect(formulario.send(:visible_for_aluno?, aluno)).to be false
        end
      end
    end
  end
end
