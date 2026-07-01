# frozen_string_literal: true

require "rails_helper"

RSpec.describe "layouts/dashboard_shared/_flash", type: :view do
  it "renderiza mensagens de sucesso como dialog temporario" do
    flash[:success] = "Convites enviados para <strong>2</strong> usuários."

    render partial: "layouts/dashboard_shared/flash"

    pagina = Nokogiri::HTML.fragment(rendered)
    dialogo = pagina.at_css(
      "dialog.app-flash-dialog.app-flash-dialog--success[data-controller='flash-dialog']"
    )

    expect(dialogo).to be_present
    expect(dialogo.key?("open")).to be(true)
    expect(dialogo["data-flash-dialog-timeout-value"]).to eq("6500")
    expect(dialogo.at_css("h2").text.strip).to eq("Sucesso")
    expect(dialogo.at_css(".app-flash-dialog__content p").inner_html)
      .to include("<strong>2</strong>")
    expect(dialogo.at_css("button[aria-label='Fechar notificação']")).to be_present
    expect(pagina.at_css(".app-alert")).to be_nil
  end

  it "renderiza erros com lista detalhada como dialog temporario" do
    flash[:error] = "A importação foi concluída parcialmente."
    flash[:error_list] = [
      "Professor A: e-mail inválido.",
      "Aluno B: matrícula duplicada."
    ]

    render partial: "layouts/dashboard_shared/flash"

    pagina = Nokogiri::HTML.fragment(rendered)
    dialogo = pagina.at_css("dialog.app-flash-dialog.app-flash-dialog--error")

    expect(dialogo).to be_present
    expect(dialogo["data-flash-dialog-timeout-value"]).to eq("12000")
    expect(dialogo.at_css("h2").text.strip).to eq("Erro")
    expect(dialogo.text).to include("A importação foi concluída parcialmente.")
    expect(dialogo.css("li").map { |item| item.text.strip }).to eq(flash[:error_list])
  end

  it "renderiza avisos como dialog temporario" do
    flash[:notice] = "Não há usuários pendentes de cadastro."

    render partial: "layouts/dashboard_shared/flash"

    pagina = Nokogiri::HTML.fragment(rendered)
    dialogo = pagina.at_css("dialog.app-flash-dialog.app-flash-dialog--notice")

    expect(dialogo).to be_present
    expect(dialogo["data-flash-dialog-timeout-value"]).to eq("6500")
    expect(dialogo.at_css("h2").text.strip).to eq("Aviso")
    expect(dialogo.text).to include("Não há usuários pendentes de cadastro.")
  end
end
