document.addEventListener("DOMContentLoaded", function() {
  let questaoCount = document.querySelectorAll(".questao-fields").length;

  function addFields(container, className) {
    let newFields = container.firstElementChild.cloneNode(true);
    let newIndex = container.children.length;
    newFields.querySelectorAll("input, select").forEach(function(input) {
      input.name = input.name.replace(/\d+/, newIndex);
      input.id = input.id.replace(/\d+/, newIndex);
      if (input.type !== "hidden") input.value = "";
    });
    container.appendChild(newFields);
  }

  document.getElementById("add-questao").addEventListener("click", function(e) {
    e.preventDefault();
    let questoesContainer = document.getElementById("questoes-container");
    addFields(questoesContainer, "questao-fields");
  });

  document.getElementById("questoes-container").addEventListener("click", function(e) {
    if (e.target.classList.contains("remove-questao")) {
      e.preventDefault();
      e.target.closest(".questao-fields").remove();
    }

    if (e.target.classList.contains("add-alternativa")) {
      e.preventDefault();
      let alternativasContainer = e.target.previousElementSibling;
      addFields(alternativasContainer, "alternativa-fields");
    }

    if (e.target.classList.contains("remove-alternativa")) {
      e.preventDefault();
      e.target.closest(".alternativa-fields").remove();
    }
  });
});
