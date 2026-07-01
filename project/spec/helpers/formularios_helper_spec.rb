require "rails_helper"

RSpec.describe FormulariosHelper, type: :helper do
  describe "#formatar_resposta" do
    let(:resposta) { instance_double("Respostum", valor_numerico: nil, valor_texto: nil) }

    context "quando o tipo é boolean" do
      it "retorna 'Sim' quando o valor numérico é 1" do
        allow(resposta).to receive(:valor_numerico).and_return(1)
        expect(helper.formatar_resposta(resposta, "boolean")).to eq("Sim")
      end

      it "retorna 'Não' quando o valor numérico é 0" do
        allow(resposta).to receive(:valor_numerico).and_return(0)
        expect(helper.formatar_resposta(resposta, "boolean")).to eq("Não")
      end

      it "retorna '—' quando o valor numérico é nulo" do
        allow(resposta).to receive(:valor_numerico).and_return(nil)
        expect(helper.formatar_resposta(resposta, "boolean")).to eq("—")
      end
    end

    context "quando o tipo é rating" do
      it "retorna '4/5' quando o valor numérico é 4" do
        allow(resposta).to receive(:valor_numerico).and_return(4)
        expect(helper.formatar_resposta(resposta, "rating")).to eq("4/5")
      end

      it "retorna '—' quando o valor numérico é nulo" do
        allow(resposta).to receive(:valor_numerico).and_return(nil)
        expect(helper.formatar_resposta(resposta, "rating")).to eq("—")
      end
    end

    context "quando o tipo é text" do
      it "retorna o valor texto quando presente" do
        allow(resposta).to receive(:valor_texto).and_return("Muito bom")
        expect(helper.formatar_resposta(resposta, "text")).to eq("Muito bom")
      end

      it "retorna '—' quando o valor texto é nulo" do
        allow(resposta).to receive(:valor_texto).and_return(nil)
        expect(helper.formatar_resposta(resposta, "text")).to eq("—")
      end
    end
  end
end
