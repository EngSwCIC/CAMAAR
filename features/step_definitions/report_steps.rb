Given('I have a form for discipline "Estrutura de Dados", with professor "DANIEL DE PAULA PORTO" and semester "2020.1"') do
  Discipline.destroy_all
  Form.destroy_all

  discipline = Discipline.create(name: 'Estrutura de Dados', code: 'CIC0090', professor_registration: '000',
                                 semester_id: 1)
  form = discipline.forms.create
  form.questions.create(type: 'MultipleChoiceQuestion',
                        label: 'Como você avalia a clareza das explicações do professor durante as aulas?',
                        format: 'Muito clara|Clara|Nem clara, nem confusa|Pouco clara|Nada clara')

  discipline.save
end

Given('I have no semesters registered') do
  Semester.destroy_all
end

When('I click Baixar Resultados') do
  visit 'evaluations/1.csv'
end

When('I click Gerar CSV de Resultados deste Semestre') do
  visit 'semesters/current.csv'
end

Then('I should download a CSV file for that discipline') do
end

Then('I should download a CSV file for the disciplines of that semester') do
end

Then('I should see {string}') do |string|
  expect(page).to have_text(string)
end
