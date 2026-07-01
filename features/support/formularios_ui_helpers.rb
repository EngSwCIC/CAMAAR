# frozen_string_literal: true

module FormulariosUiHelpers
  PUBLICO_ALVO_VALORES = {
    "docentes" => "docentes",
    "discentes" => "discentes"
  }.freeze
  PUBLICO_ALVO_ROTULOS = {
    "docentes" => "Docentes",
    "discentes" => "Discentes"
  }.freeze

  def selecionar_publico_alvo_no_dropdown(publico_alvo)
    alterar_publico_alvo_no_dropdown(valor_publico_alvo(publico_alvo))
  end

  def limpar_publico_alvo_no_dropdown
    alterar_publico_alvo_no_dropdown("")
  end

  def selecionar_template_no_formulario(titulo)
    template = Template.find_by!(titulo: titulo)

    if rack_test_driver?
      find("input[name='template_id'][value='#{template.id}']", visible: :all).set(true)
    else
      find(".formulario-template-card", text: titulo).click
    end
  end

  def esperar_template_selecionado_no_formulario(titulo)
    template = Template.find_by!(titulo: titulo)

    expect(find("input[name='template_id'][value='#{template.id}']", visible: :all)).to be_checked
  end

  private

  def alterar_publico_alvo_no_dropdown(valor)
    if valor.blank?
      limpar_radio_publico_alvo
      return
    end

    if rack_test_driver?
      find("input[name='publico_alvo'][value='#{valor}']", visible: :all).set(true)
    else
      find(".formulario-publico-segmented__option", text: PUBLICO_ALVO_ROTULOS.fetch(valor)).click
    end
  end

  def limpar_radio_publico_alvo
    return if rack_test_driver?

    page.execute_script(
      "document.querySelectorAll('input[name=\"publico_alvo\"]').forEach((input) => { " \
      "input.checked = false; " \
      "});"
    )
  end

  def rack_test_driver?
    page.driver.is_a?(Capybara::RackTest::Driver)
  end

  def valor_publico_alvo(publico_alvo)
    PUBLICO_ALVO_VALORES.fetch(publico_alvo.to_s.downcase)
  end
end

World(FormulariosUiHelpers)
