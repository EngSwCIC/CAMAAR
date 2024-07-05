require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#current_page_title" do
    it "returns 'Gerenciamento' when view_name includes 'gerenciamento'" do
      allow(helper).to receive(:controller_name).and_return("gerenciamento")
      allow(helper).to receive(:action_name).and_return("index")
      expect(helper.current_page_title).to eq("Gerenciamento")
    end

    it "returns 'Gerenciamento - Resultados' when view_name includes 'resultados'" do
      allow(helper).to receive(:controller_name).and_return("resultados")
      allow(helper).to receive(:action_name).and_return("show")
      expect(helper.current_page_title).to eq("Gerenciamento - Resultados")
    end

    it "returns 'Gerenciamento - Templates' when view_name includes 'template'" do
      allow(helper).to receive(:controller_name).and_return("template")
      allow(helper).to receive(:action_name).and_return("edit")
      expect(helper.current_page_title).to eq("Gerenciamento - Templates")
    end

    it "returns 'Gerenciamento - Enviar Formulários' when view_name includes 'enviarFormularios'" do
      allow(helper).to receive(:controller_name).and_return("enviarFormularios")
      allow(helper).to receive(:action_name).and_return("new")
      expect(helper.current_page_title).to eq("Gerenciamento - Enviar Formulários")
    end

    it "returns 'Avaliações' when view_name does not match any specific condition" do
      allow(helper).to receive(:controller_name).and_return("avaliacoes")
      allow(helper).to receive(:action_name).and_return("index")
      expect(helper.current_page_title).to eq("Avaliações")
    end
  end
end
