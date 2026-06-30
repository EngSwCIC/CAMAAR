require 'rails_helper'

RSpec.describe SigaaImporter do
  let(:classes) do
    [
      { "code" => "CIC0097", "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" } }
    ]
  end

  let(:members) do
    [
      {
        "code" => "CIC0097", "classCode" => "TA", "semester" => "2021.2",
        "dicente" => [
          { "nome" => "Ana Clara", "matricula" => "190084006", "usuario" => "190084006",
            "email" => "ana@x.com", "ocupacao" => "dicente" }
        ],
        "docente" => { "nome" => "Maristela", "usuario" => "83807519491",
                       "email" => "prof@x.com", "ocupacao" => "docente" }
      }
    ]
  end

  it "cria turmas, usuários e matrículas" do
    counts = SigaaImporter.call(classes: classes, members: members)

    expect(Turma.count).to eq(1)
    expect(User.count).to eq(2)
    expect(Enrollment.count).to eq(2)
    expect(counts).to eq(turmas: 1, users: 2, enrollments: 2)

    turma = Turma.first
    expect(turma.discentes.pluck(:email)).to contain_exactly("ana@x.com")
    expect(turma.docente.email).to eq("prof@x.com")
  end

  it "é idempotente (não duplica ao rodar de novo)" do
    SigaaImporter.call(classes: classes, members: members)
    SigaaImporter.call(classes: classes, members: members)

    expect(Turma.count).to eq(1)
    expect(User.count).to eq(2)
    expect(Enrollment.count).to eq(2)
  end

  it "matricula apenas o docente quando não há discentes" do
    members_so_docente = [
      {
        "code" => "CIC0097", "classCode" => "TA", "semester" => "2021.2",
        "docente" => { "nome" => "Maristela", "usuario" => "83807519491", "email" => "prof@x.com", "ocupacao" => "docente" }
      }
    ]
    counts = SigaaImporter.call(classes: classes, members: members_so_docente)

    expect(counts).to eq(turmas: 1, users: 1, enrollments: 1)
    expect(Turma.first.docente.email).to eq("prof@x.com")
  end

  it "ignora membros cuja turma não foi informada em classes" do
    members_sem_turma = [
      {
        "code" => "INEXISTENTE", "classCode" => "ZZ", "semester" => "2021.2",
        "dicente" => [ { "nome" => "Zé", "matricula" => "1", "email" => "ze@x.com" } ]
      }
    ]
    counts = SigaaImporter.call(classes: [], members: members_sem_turma)

    expect(counts).to eq(turmas: 0, users: 0, enrollments: 0)
    expect(User.count).to eq(0)
  end

  context "Sad Path" do
    it "não quebra o sistema e retorna contagem zero se receber dados vazios" do
      counts = SigaaImporter.call(classes: [], members: [])

      expect(counts).to eq(turmas: 0, users: 0, enrollments: 0)
      expect(Turma.count).to eq(0)
      expect(User.count).to eq(0)
    end

    it "aceita classes e members nulos sem levantar erro" do
      expect { SigaaImporter.call(classes: nil, members: nil) }.not_to raise_error
    end
  end
end
