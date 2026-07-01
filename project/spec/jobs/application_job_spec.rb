require "rails_helper"

RSpec.describe ApplicationJob do
  it "é uma subclasse de ActiveJob::Base" do
    expect(described_class.superclass).to eq(ActiveJob::Base)
  end

  it "pode ser instanciado" do
    expect { described_class.new }.not_to raise_error
  end
end
