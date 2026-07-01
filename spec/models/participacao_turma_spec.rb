require "rails_helper"

RSpec.describe ParticipacaoTurma, type: :model do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:turma) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }

  describe "#corresponde_ao_publico?" do
    it "retorna true para docente quando público-alvo é docentes" do
      participacao = create_participacao(
        usuario: create_usuario,
        turma: turma,
        tipo_participacao: :docente
      )

      expect(participacao.corresponde_ao_publico?(:docentes)).to be(true)
      expect(participacao.corresponde_ao_publico?("docentes")).to be(true)
    end

    it "retorna false para docente quando público-alvo é discentes" do
      participacao = create_participacao(
        usuario: create_usuario,
        turma: turma,
        tipo_participacao: :docente
      )

      expect(participacao.corresponde_ao_publico?(:discentes)).to be(false)
    end

    it "retorna true para discente quando público-alvo é discentes" do
      participacao = create_participacao(
        usuario: create_usuario,
        turma: turma,
        tipo_participacao: :discente
      )

      expect(participacao.corresponde_ao_publico?(:discentes)).to be(true)
    end

    it "retorna false para público-alvo inválido" do
      participacao = create_participacao(
        usuario: create_usuario,
        turma: turma,
        tipo_participacao: :discente
      )

      expect(participacao.corresponde_ao_publico?(:invalido)).to be(false)
    end
  end
end
