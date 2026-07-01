require "rails_helper"

RSpec.describe Avaliacao, type: :model do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:turma) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm) }

  describe "validação de público-alvo" do
    it "rejeita participação docente em formulário para discentes" do
      docente = create_usuario
      participacao = create_participacao(usuario: docente, turma: turma, tipo_participacao: :docente)
      formulario = create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes
      )

      avaliacao = described_class.new(formulario: formulario, participacao_turma: participacao)

      expect(avaliacao).not_to be_valid
      expect(avaliacao.errors[:participacao_turma]).to include("não corresponde ao público-alvo do formulário")
    end

    it "rejeita participação discente em formulário para docentes" do
      discente = create_usuario
      participacao = create_participacao(usuario: discente, turma: turma, tipo_participacao: :discente)
      formulario = create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :docentes
      )

      avaliacao = described_class.new(formulario: formulario, participacao_turma: participacao)

      expect(avaliacao).not_to be_valid
      expect(avaliacao.errors[:participacao_turma]).to include("não corresponde ao público-alvo do formulário")
    end

    it "aceita participação compatível com o público-alvo" do
      docente = create_usuario
      participacao = create_participacao(usuario: docente, turma: turma, tipo_participacao: :docente)
      formulario = create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :docentes
      )

      avaliacao = described_class.new(formulario: formulario, participacao_turma: participacao)

      expect(avaliacao).to be_valid
    end
  end
end
