Then(/^the classes, subjects, and participants should be added to the database if they do not already exist$/) do
  expect(Class.count).to be > 0
  expect(Subject.count).to be > 0
  expect(Participant.count).to be > 0
end

Given(/^there are existing classes, subjects, and participants in the database$/) do
  @existing_class = Class.create(name: 'Existing Class')
  @existing_subject = Subject.create(name: 'Existing Subject')
  @existing_participant = Participant.create(name: 'Existing Participant')
end

Then(/^the existing data should not be duplicated$/) do
  # Check that there are no duplicates in the database
  expect(Class.where(name: 'Existing Class').count).to eq(1)
  expect(Subject.where(name: 'Existing Subject').count).to eq(1)
  expect(Participant.where(name: 'Existing Participant').count).to eq(1)
end

