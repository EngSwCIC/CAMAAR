document.addEventListener("DOMContentLoaded", function() {
  var questionTypeSelect = document.getElementById('question_type');
  var choicesField = document.getElementById('choices_field');
  var optionsFields = document.getElementById('options_fields');

  questionTypeSelect.addEventListener('change', function() {
    if (questionTypeSelect.value === 'multiple_choice') {
      choicesField.style.display = 'block';
    } else {
      choicesField.style.display = 'none';
    }
  });

  var optionsNumberSelect = document.getElementById('options_number');
  optionsNumberSelect.addEventListener('change', function() {
    var optionsNumber = parseInt(optionsNumberSelect.value);
    for (var i = 0; i < optionsFields.children.length; i++) {
      var optionField = optionsFields.children[i];
      if (i < optionsNumber) {
        optionField.style.display = 'block';
      } else {
        optionField.style.display = 'none';
      }
    }
  });

  // Initial check for the question type and options number on page load
  if (questionTypeSelect.value === 'multiple_choice') {
    choicesField.style.display = 'block';
  }
  var initialOptionsNumber = parseInt(optionsNumberSelect.value);
  for (var i = 0; i < optionsFields.children.length; i++) {
    var optionField = optionsFields.children[i];
    if (i < initialOptionsNumber) {
      optionField.style.display = 'block';
    } else {
      optionField.style.display = 'none';
    }
  }
});
