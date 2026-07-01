require "rails_helper"

RSpec.describe "Versionamento de Template", type: :model do
  it "cria uma nova versão do template" do
    antigo = Template.create!(nome: "Modelo A")

    novo = antigo.dup
    novo.nome = "Modelo B"
    novo.parent_template = antigo
    novo.save!

    expect(Template.count).to eq(2)
    expect(novo.parent_template).to eq(antigo)
  end
end