require 'rails_helper'

RSpec.describe Usuario, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      usuario = Usuario.new(nome: 'Test User', email: 'test@unb.br', perfil: 'discente', ativo: true)
      usuario.password = '123456'
      expect(usuario).to be_valid
    end

    it 'is not valid without an email' do
      usuario = Usuario.new(nome: 'Test', email: nil, perfil: 'discente')
      expect(usuario).not_to be_valid
    end
  end

  describe 'setup token' do
    it 'generates a setup token' do
      usuario = Usuario.create(nome: 'Test User', email: 'test@unb.br', perfil: 'discente', ativo: false, password: 'password123')
      usuario.generate_setup_token!
      expect(usuario.setup_token).to be_present
      expect(usuario.setup_token_sent_at).to be_present
      expect(usuario.setup_token_used).to be false
    end
  end

  describe 'reset token' do
    it 'generates a reset token' do
      usuario = Usuario.create(nome: 'Test User', email: 'test@unb.br', perfil: 'discente', ativo: true, password: 'password123')
      usuario.generate_reset_token!
      expect(usuario.reset_token).to be_present
      expect(usuario.reset_token_sent_at).to be_present
      expect(usuario.reset_token_used).to be false
    end
  end

  # --- INÍCIO DOS TESTES DA ISSUE #106 (ESTADO RED) ---
  describe "Regras de permissão por departamento (Issue #106)" do
    describe "#pode_gerenciar_turma?" do
      let(:departamento_cic) { Departamento.create!(nome: "Ciência da Computação") }
      let(:departamento_mat) { Departamento.create!(nome: "Matemática") }
      let(:disciplina_cic) { Disciplina.create!(nome: "Engenharia de Software", codigo: "CIC001") }
      let(:disciplina_mat) { Disciplina.create!(nome: "Cálculo 1", codigo: "MAT001") }
      let(:turma_cic) { Turma.create!(disciplina: disciplina_cic, departamento: departamento_cic, codigo_turma: "CIC001A", semestre: "2026.1") }
      let(:turma_mat) { Turma.create!(disciplina: disciplina_mat, departamento: departamento_mat, codigo_turma: "MAT001A", semestre: "2026.1") }
      let(:admin) do
        usuario = Usuario.new(nome: 'Admin', email: 'admin@unb.br', perfil: 'administrador', departamento: departamento_cic)
        usuario.password = '123456'
        usuario.save!
        usuario
      end

      it "retorna verdadeiro se a turma pertencer ao mesmo departamento do administrador" do
        expect(admin.pode_gerenciar_turma?(turma_cic)).to be true
      end

      it "retorna falso se a turma pertencer a um departamento diferente" do
        expect(admin.pode_gerenciar_turma?(turma_mat)).to be false
      end
    end
  end
end
