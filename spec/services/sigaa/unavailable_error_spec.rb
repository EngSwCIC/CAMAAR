# frozen_string_literal: true

require "rails_helper"

RSpec.describe SIGAA::UnavailableError do
  it "expõe a mensagem de flash para indisponibilidade do SIGAA" do
    expect(described_class.new.flash_message)
      .to eq("Não foi possível buscar os dados. Tente novamente mais tarde.")
  end
end
