Given('there is at least one form answered for {string}') do |string|
  @class = Class.create(name: string)
  ClassForm.create(name: 'Form', class: @class)
end

Given('there is no form answered for {string}') do |string|
  @class = Class.find(name: string)
  ClassForm.where(class: @class).destroy_all
end