require 'rails_helper'

RSpec.describe Turma, type: :model do
  let!(:dcc) { Departamento.create!(nome: 'DEPTO CIÊNCIAS DA COMPUTAÇÃO') }
  let!(:disc) { Disciplina.create!(codigo: 'CIC0004', nome: 'Algoritmos e Programação de Computadores') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      turma = Turma.new(codigo_turma: 'Turma A', semestre: '2023.2', disciplina: disc, departamento: dcc)
      expect(turma).to be_valid
    end

    it 'is invalid without a codigo_turma' do
      turma = Turma.new(codigo_turma: nil, semestre: '2023.2', disciplina: disc, departamento: dcc)
      expect(turma).not_to be_valid
      expect(turma.errors[:codigo_turma]).to be_present
    end

    it 'is invalid without a semestre' do
      turma = Turma.new(codigo_turma: 'Turma A', semestre: nil, disciplina: disc, departamento: dcc)
      expect(turma).not_to be_valid
      expect(turma.errors[:semestre]).to be_present
    end

    it 'is invalid with a duplicate codigo_turma in the same semestre' do
      Turma.create!(codigo_turma: 'Turma A', semestre: '2023.2', disciplina: disc, departamento: dcc)
      duplicate_turma = Turma.new(codigo_turma: 'Turma A', semestre: '2023.2', disciplina: disc, departamento: dcc)
      expect(duplicate_turma).not_to be_valid
      expect(duplicate_turma.errors[:codigo_turma]).to be_present
    end

    it 'is valid with a duplicate codigo_turma in a different semestre' do
      Turma.create!(codigo_turma: 'Turma A', semestre: '2023.2', disciplina: disc, departamento: dcc)
      different_semestre_turma = Turma.new(codigo_turma: 'Turma A', semestre: '2024.1', disciplina: disc, departamento: dcc)
      expect(different_semestre_turma).to be_valid
    end
  end

  describe 'helper methods' do
    let!(:turma) { Turma.create!(codigo_turma: 'Turma A', semestre: '2023.2', disciplina: disc, departamento: dcc) }

    describe '#codigo' do
      it 'returns the associated discipline code' do
        expect(turma.codigo).to eq('CIC0004')
      end
    end

    describe '#nome' do
      it 'returns the class code' do
        expect(turma.nome).to eq('Turma A')
      end
    end

    describe '#matriculas_count' do
      it 'returns the number of matriculas associated with the class' do
        expect(turma.matriculas_count).to eq(0)

        student = Usuario.new(nome: 'Aluno', email: 'aluno@unb.br', perfil: 'discente', ativo: true)
        student.password = 'senha123'
        student.save!

        Matricula.create!(turma: turma, usuario: student, papel_na_turma: 'aluno')

        expect(turma.reload.matriculas_count).to eq(1)
      end
    end

    describe '#respostas_count' do
      it 'returns the number of responses for forms associated with the class' do
        expect(turma.respostas_count).to eq(0)

        # Create template & student & enrollment
        template = Template.create!(
          titulo: 'Feedback Geral',
          criador: Usuario.create!(nome: 'Admin', email: 'admin@unb.br', matricula: 'admin_mat', perfil: 'administrador', password: 'admin', ativo: true),
          skip_questions_validation: true
        )

        student = Usuario.create!(nome: 'Aluno', email: 'aluno_resp@unb.br', perfil: 'discente', ativo: true, password: 'senha')
        Matricula.create!(turma: turma, usuario: student, papel_na_turma: 'aluno')

        form = Formulario.create!(
          template: template,
          turma: turma,
          criado_por: template.criador,
          publico_alvo: 'discente',
          status: 'aberto',
          data_inicio: Time.current,
          data_limite: Time.current + 7.days
        )

        Resposta.create!(formulario: form, usuario: student, enviado_em: Time.current)

        expect(turma.respostas_count).to eq(1)
      end
    end
  end
end
