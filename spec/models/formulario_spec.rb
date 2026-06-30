require 'rails_helper'

RSpec.describe Formulario, type: :model do
  describe "Regras de público-alvo na criação (Issue #113)" do
    let(:departamento) { Departamento.create!(nome: "Engenharia") }
    let(:disciplina) { Disciplina.create!(nome: "Engenharia de Software", codigo: "ENS101") }
    let(:admin) do
      usuario = Usuario.new(nome: "Admin", email: "admin_test@camaar.com", perfil: "administrador")
      usuario.password = "Senha123"
      usuario.save!
      usuario
    end
    let(:template) { Template.create!(titulo: "Template Padrão", ativo: true, criador_id: admin.id, skip_questions_validation: true) }
    let(:turma) do
      Turma.create!(
        codigo_turma: "ENS101-2024",
        semestre: "2024.1",
        disciplina_id: disciplina.id,
        departamento_id: departamento.id
      )
    end

    it "é inválido se o público-alvo (docentes ou discentes) não for preenchido" do
      formulario = Formulario.new(publico_alvo: nil, template: template, turma: turma)

      expect(formulario).not_to be_valid
      expect(formulario.errors[:publico_alvo]).to include("Obrigatório: Selecione se o formulário é destinado a docentes ou discentes.")
    end

    it "impede a criação para discentes se a turma não possuir alunos matriculados" do
      formulario = Formulario.new(turma: turma, publico_alvo: 'discente', template: template)

      expect(formulario).not_to be_valid
      expect(formulario.errors[:base]).to include("Ação inválida: Esta turma ainda não possui discentes vinculados no SIGAA para responderem à avaliação.")
    end

    it "impede a criação de um novo formulário se já houver um ativo para o mesmo público na turma" do
      discente = Usuario.new(nome: "Aluno", email: "aluno@camaar.com", perfil: "discente")
      discente.password = "Senha123"
      discente.save!

      turma.matriculas.create!(usuario: discente, papel_na_turma: 'discente')

      Formulario.create!(
        turma: turma,
        publico_alvo: 'discente',
        status: 'aberto',
        template: template,
        criado_por: admin,
        data_inicio: Time.current,
        data_limite: Time.current + 1.day
      )

      novo_formulario = Formulario.new(
        turma: turma,
        publico_alvo: 'discente',
        status: 'aberto',
        template: template,
        criado_por: admin,
        data_inicio: Time.current,
        data_limite: Time.current + 1.day
      )

      expect(novo_formulario).not_to be_valid
      expect(novo_formulario.errors[:base]).to include("Atenção: Já existe um formulário ativo para os discentes desta turma. Encerre o atual antes de publicar um novo.")
    end
  end
end
