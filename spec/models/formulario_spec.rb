require "rails_helper"

RSpec.describe Formulario, type: :model do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:turma) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:template) { create_template_with_questoes(titulo: "Avaliação", adm: admin.perfil_adm) }

  describe "validações" do
    it "exige perfil administrativo" do
      formulario = described_class.new

      expect(formulario).not_to be_valid
      expect(formulario.errors[:adm]).to include("é obrigatório(a)")
    end

    it "rejeita administrador de departamento diferente da turma" do
      outro_departamento = Departamento.create!(nome: "IC #{SecureRandom.hex(2)}")
      outro_admin = create_admin_usuario(departamento: outro_departamento)
      formulario = described_class.new(
        adm: outro_admin.perfil_adm,
        turma: turma,
        template: template,
        publico_alvo: :docentes
      )

      expect(formulario).not_to be_valid
      expect(formulario.errors[:adm]).to include("deve pertencer ao mesmo departamento da turma")
    end

    it "impede duplicata de público-alvo para mesma turma e template" do
      create_formulario(turma: turma, adm: admin.perfil_adm, template: template, publico_alvo: :docentes)

      duplicata = described_class.new(
        adm: admin.perfil_adm,
        turma: turma,
        template: template,
        publico_alvo: :docentes
      )

      expect(duplicata).not_to be_valid
      expect(duplicata.errors[:publico_alvo]).to include("já possui formulário para esta turma e template")
    end
  end

  describe "#criado_por?" do
    let(:formulario) { create_formulario(turma: turma, adm: admin.perfil_adm, template: template) }

    it "retorna true quando o administrador é o criador" do
      expect(formulario.criado_por?(admin.perfil_adm)).to be(true)
    end

    it "retorna false para outro administrador" do
      outro_admin = create_admin_usuario(departamento: departamento)

      expect(formulario.criado_por?(outro_admin.perfil_adm)).to be(false)
    end
  end

  describe "scopes" do
    let!(:formulario_proprio) { create_formulario(turma: turma, adm: admin.perfil_adm, template: template) }
    let!(:formulario_outro_admin) do
      outro_admin = create_admin_usuario(departamento: departamento)
      outro_template = create_template_with_questoes(titulo: "Outro", adm: outro_admin.perfil_adm)
      create_formulario(
        turma: create_turma(nome_materia: "IHC", numero: 2, departamento: departamento),
        adm: outro_admin.perfil_adm,
        template: outro_template
      )
    end
    let!(:formulario_outro_depto) do
      outro_departamento = Departamento.create!(nome: "IC #{SecureRandom.hex(2)}")
      outro_admin = create_admin_usuario(departamento: outro_departamento)
      outro_turma = create_turma(nome_materia: "ES", numero: 1, departamento: outro_departamento)
      outro_template = create_template_with_questoes(titulo: "Externo", adm: outro_admin.perfil_adm)
      create_formulario(turma: outro_turma, adm: outro_admin.perfil_adm, template: outro_template)
    end

    it "criados_por filtra formulários do administrador informado" do
      expect(described_class.criados_por(admin.perfil_adm)).to contain_exactly(formulario_proprio)
    end

    it "criados_por_outros exclui formulários do administrador informado" do
      expect(described_class.criados_por_outros(admin.perfil_adm)).to contain_exactly(
        formulario_outro_admin,
        formulario_outro_depto
      )
    end

    it "do_departamento exclui formulários de outro departamento" do
      expect(described_class.do_departamento(departamento)).to contain_exactly(
        formulario_proprio,
        formulario_outro_admin
      )
    end
  end

  describe "#participacoes_alvo" do
    let!(:docente) do
      usuario = create_usuario
      create_participacao(usuario: usuario, turma: turma, tipo_participacao: :docente)
      usuario.participacoes_turma.sole
    end

    let!(:discente) do
      usuario = create_usuario
      create_participacao(usuario: usuario, turma: turma, tipo_participacao: :discente)
      usuario.participacoes_turma.sole
    end

    it "retorna participações docentes quando público-alvo é docentes" do
      formulario = create_formulario(turma: turma, adm: admin.perfil_adm, template: template, publico_alvo: :docentes)

      expect(formulario.participacoes_alvo).to contain_exactly(docente)
    end

    it "retorna participações discentes quando público-alvo é discentes" do
      formulario = create_formulario(turma: turma, adm: admin.perfil_adm, template: template, publico_alvo: :discentes)

      expect(formulario.participacoes_alvo).to contain_exactly(discente)
    end

    it "retorna relação vazia quando público-alvo não é reconhecido" do
      formulario = create_formulario(turma: turma, adm: admin.perfil_adm, template: template, publico_alvo: :docentes)
      allow(formulario).to receive(:docentes?).and_return(false)
      allow(formulario).to receive(:discentes?).and_return(false)

      expect(formulario.participacoes_alvo).to eq(ParticipacaoTurma.none)
    end
  end

  describe "#criar_avaliacoes_pendentes!" do
    let!(:docente) do
      usuario = create_usuario
      create_participacao(usuario: usuario, turma: turma, tipo_participacao: :docente)
      usuario
    end

    let!(:discente) do
      usuario = create_usuario
      create_participacao(usuario: usuario, turma: turma, tipo_participacao: :discente)
      usuario
    end

    it "cria avaliações pendentes para cada participação do público-alvo" do
      formulario = create_formulario(turma: turma, adm: admin.perfil_adm, template: template, publico_alvo: :docentes)

      expect do
        formulario.criar_avaliacoes_pendentes!
      end.to change(Avaliacao, :count).by(1)

      avaliacao = formulario.avaliacoes.sole
      expect(avaliacao).to be_pendente
      expect(avaliacao.participacao_turma.usuario).to eq(docente)
    end

    it "não duplica avaliações existentes" do
      formulario = create_formulario(
        turma: turma,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes,
        criar_avaliacoes: true
      )

      expect do
        formulario.criar_avaliacoes_pendentes!
      end.not_to change(Avaliacao, :count)
    end
  end
end
