require "application_system_test_case"

class MateriasTest < ApplicationSystemTestCase
  setup do
    @materia = materias(:one)
  end

  test "visiting the index" do
    visit materias_url
    assert_selector "h1", text: "Materias"
  end

  test "should create materia" do
    visit materias_url
    click_on "New materia"

    fill_in "Code", with: @materia.code
    fill_in "Nome", with: @materia.nome
    click_on "Create Materia"

    assert_text "Materia was successfully created"
    click_on "Back"
  end

  test "should update Materia" do
    visit materia_url(@materia)
    click_on "Edit this materia", match: :first

    fill_in "Code", with: @materia.code
    fill_in "Nome", with: @materia.nome
    click_on "Update Materia"

    assert_text "Materia was successfully updated"
    click_on "Back"
  end

  test "should destroy Materia" do
    visit materia_url(@materia)
    click_on "Destroy this materia", match: :first

    assert_text "Materia was successfully destroyed"
  end
end
