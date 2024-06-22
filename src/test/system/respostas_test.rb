require "application_system_test_case"

class RespostasTest < ApplicationSystemTestCase
  setup do
    @resposta = respostas(:one)
  end

  test "visiting the index" do
    visit respostas_url
    assert_selector "h1", text: "Respostas"
  end

  test "should create resposta" do
    visit respostas_url
    click_on "New resposta"

    fill_in "Id formulario", with: @resposta.id_formulario
    fill_in "Id questao", with: @resposta.id_questao
    fill_in "Numero", with: @resposta.numero
    fill_in "Resposta", with: @resposta.resposta
    fill_in "Usuario", with: @resposta.usuario
    click_on "Create Resposta"

    assert_text "Resposta was successfully created"
    click_on "Back"
  end

  test "should update Resposta" do
    visit resposta_url(@resposta)
    click_on "Edit this resposta", match: :first

    fill_in "Id formulario", with: @resposta.id_formulario
    fill_in "Id questao", with: @resposta.id_questao
    fill_in "Numero", with: @resposta.numero
    fill_in "Resposta", with: @resposta.resposta
    fill_in "Usuario", with: @resposta.usuario
    click_on "Update Resposta"

    assert_text "Resposta was successfully updated"
    click_on "Back"
  end

  test "should destroy Resposta" do
    visit resposta_url(@resposta)
    click_on "Destroy this resposta", match: :first

    assert_text "Resposta was successfully destroyed"
  end
end
