# frozen_string_literal: true

require "rails_helper"

RSpec.describe SIGAA::ImportData do
  let(:path) { Rails.root.join("tmp", "usuarios_sigaa_spec.json") }
  let!(:departamento) { Departamento.create!(nome: "Departamento SIGAA") }

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:read).and_call_original
  end

  it "retorna erro de domínio quando o arquivo não existe" do
    allow(File).to receive(:exist?).with(path).and_return(false)

    result = described_class.call(path: path)

    expect(result).to be_missing_file
    expect(result.message).to eq("Arquivo JSON não encontrado em db/")
  end

  it "importa matérias, turmas, docentes e discentes do JSON" do
    stub_import_file(valid_json)

    expect do
      result = described_class.call(path: path)
      expect(result).to be_success
    end.to change(Materia, :count).by(1)
      .and change(Turma, :count).by(1)
      .and change(Usuario, :count).by(2)

    expect(Usuario.find_by!(matricula: "2026001")).to be_docente
    expect(Usuario.find_by!(matricula: "26100001")).to be_discente
  end

  it "usa o departamento_id informado no JSON" do
    json = valid_json
    stub_import_file(json)

    result = described_class.call(path: path)

    expect(result).to be_success
    expect(Materia.find_by!(codigo: "CIC0001").departamento).to eq(departamento)
    expect(Usuario.find_by!(matricula: "2026001").perfil_docente.departamento).to eq(departamento)
  end

  it "preserva administradores ausentes do JSON ao remover usuários obsoletos" do
    admin = create_admin_usuario(
      departamento: departamento,
      matricula: "ADM-FORA-JSON",
      email: "admin-fora-json@unb.br"
    )
    usuario_obsoleto = create_usuario(
      matricula: "USR-FORA-JSON",
      email: "usuario-fora-json@unb.br",
      status: :pendente
    )

    stub_import_file(empty_json)

    result = described_class.call(path: path)

    expect(result).to be_success
    expect(Usuario.exists?(admin.id)).to be(true)
    expect(Usuario.exists?(usuario_obsoleto.id)).to be(false)
  end

  it "acumula erro parcial quando uma participação aponta para turma inexistente" do
    stub_import_file(invalid_discente_json)

    result = described_class.call(path: path)

    expect(result).to be_partial
    expect(result.errors).to include(
      "Discente Rafael Sapienza (Matrícula: 26100001): Turma nº 999 (2026/1) da matéria 'Estruturas de Dados' não foi localizada no sistema."
    )
  end

  def stub_import_file(json)
    allow(File).to receive(:exist?).with(path).and_return(true)
    allow(File).to receive(:read).with(path).and_return(json.to_json)
  end

  def valid_json
    {
      "materias" => [
        { "codigo" => "CIC0001", "nome" => "Estruturas de Dados", "departamento_id" => departamento.id }
      ],
      "turmas" => [
        { "numero" => 1, "ano" => 2026, "semestre" => 1, "materia_codigo" => "CIC0001" }
      ],
      "usuarios_docentes" => [
        {
          "matricula" => "2026001",
          "nome" => "Prof Teste",
          "email" => "prof@unb.br",
          "departamento_id" => departamento.id,
          "turmas_lecionadas" => [
            { "materia_codigo" => "CIC0001", "numero_turma" => 1, "ano" => 2026, "semestre" => 1 }
          ]
        }
      ],
      "usuarios_discentes" => [
        {
          "matricula" => "26100001",
          "nome" => "Rafael Sapienza",
          "email" => "rafael@unb.br",
          "turmas_matriculadas" => [
            { "materia_codigo" => "CIC0001", "numero_turma" => 1, "ano" => 2026, "semestre" => 1 }
          ]
        }
      ]
    }
  end

  def invalid_discente_json
    valid_json.merge(
      "turmas" => [],
      "usuarios_docentes" => [],
      "usuarios_discentes" => [
        {
          "matricula" => "26100001",
          "nome" => "Rafael Sapienza",
          "email" => "rafael@unb.br",
          "turmas_matriculadas" => [
            { "materia_codigo" => "CIC0001", "numero_turma" => 999, "ano" => 2026, "semestre" => 1 }
          ]
        }
      ]
    )
  end

  def empty_json
    {
      "materias" => [],
      "turmas" => [],
      "usuarios_docentes" => [],
      "usuarios_discentes" => []
    }
  end
end
