require "rails_helper"

RSpec.describe Template, type: :model do
  it "é válido com nome" do
    template = Template.new(nome: "Relatório")

    expect(template).to be_valid
  end

  it "é inválido sem nome" do
    template = Template.new(nome: nil)

    expect(template).not_to be_valid
  end
end