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
end
