require 'rails_helper'

RSpec.describe Matricula, type: :model do
  describe 'validations' do
    let!(:dcc) { Departamento.create!(nome: 'DEPTO CIÊNCIAS DA COMPUTAÇÃO') }
    let!(:disc) { Disciplina.create!(codigo: 'CIC0004', nome: 'Algoritmos e Programação de Computadores') }
    let!(:turma) do
      Turma.create!(
        codigo_turma: 'Turma A',
        semestre: '2023.2',
        disciplina: disc,
        departamento: dcc
      )
    end
    let!(:usuario) do
      u = Usuario.new(nome: 'Estudante', email: 'estudante@unb.br', perfil: 'discente', ativo: true)
      u.password = 'senha123'
      u.save!
      u
    end

    it 'is valid with valid attributes' do
      mat = Matricula.new(turma: turma, usuario: usuario, papel_na_turma: 'aluno')
      expect(mat).to be_valid
    end

    it 'is invalid without a papel_na_turma' do
      mat = Matricula.new(turma: turma, usuario: usuario, papel_na_turma: nil)
      expect(mat).not_to be_valid
      expect(mat.errors[:papel_na_turma]).to be_present
    end

    it 'is invalid if user is already enrolled in the same class' do
      Matricula.create!(turma: turma, usuario: usuario, papel_na_turma: 'aluno')
      duplicate_mat = Matricula.new(turma: turma, usuario: usuario, papel_na_turma: 'aluno')
      expect(duplicate_mat).not_to be_valid
      expect(duplicate_mat.errors[:usuario_id]).to be_present
    end
  end
end
