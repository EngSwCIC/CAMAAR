require "application_system_test_case"

class TurmasTest < ApplicationSystemTestCase
  setup do
    @turma = turmas(:one)
  end

  test "visiting the index" do
    visit turmas_url
    assert_selector "h1", text: "Turmas"
  end

  test "should create turma" do
    visit turmas_url
    click_on "New turma"

    fill_in "Classcode", with: @turma.classCode
    fill_in "Id professor", with: @turma.id_professor
    fill_in "Materia", with: @turma.materia
    fill_in "Semestre", with: @turma.semestre
    click_on "Create Turma"

    assert_text "Turma was successfully created"
    click_on "Back"
  end

  test "should update Turma" do
    visit turma_url(@turma)
    click_on "Edit this turma", match: :first

    fill_in "Classcode", with: @turma.classCode
    fill_in "Id professor", with: @turma.id_professor
    fill_in "Materia", with: @turma.materia
    fill_in "Semestre", with: @turma.semestre
    click_on "Update Turma"

    assert_text "Turma was successfully updated"
    click_on "Back"
  end

  test "should destroy Turma" do
    visit turma_url(@turma)
    click_on "Destroy this turma", match: :first

    assert_text "Turma was successfully destroyed"
  end
end
