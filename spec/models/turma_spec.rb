# frozen_string_literal: true

require "rails_helper"

RSpec.describe Turma, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe ".semestre_atual" do
    after { travel_back }

    it "mantem o primeiro semestre ate o fim de julho" do
      travel_to Date.new(2026, 7, 31)

      expect(described_class.semestre_atual).to eq(:primeiro)
    end

    it "inicia o segundo semestre em agosto" do
      travel_to Date.new(2026, 8, 1)

      expect(described_class.semestre_atual).to eq(:segundo)
    end
  end
end
