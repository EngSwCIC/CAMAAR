# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationPolicy do
  it "expõe o perfil administrador do usuário atual" do
    usuario = create_admin_usuario

    expect(described_class.new(usuario, Object.new).current_administrador)
      .to eq(usuario.perfil_adm)
  end

  it "resolve o escopo padrão como vazio" do
    scope = class_double(Template, none: "vazio")

    expect(described_class.scope(nil, scope)).to eq("vazio")
  end
end
