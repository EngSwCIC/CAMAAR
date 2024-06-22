document.addEventListener('DOMContentLoaded', function() {
      var templateButton = document.getElementById('templatesButton');
      var managementButton = document.getElementById('managementButton');
      var templatesContainer = document.getElementById('templatesContainer');
      var managementContents = document.getElementById('managementContents');
      
      templatesButton.addEventListener('click', function() {
        templatesContainer.style.display = 'block'; // Mostra o conteúdo original
        managementContents.style.display = 'none'; // Esconde o conteúdo de gerenciamento
      });

      managementButton.addEventListener('click', function() {
        templatesContainer.style.display = 'none'; // Esconde o conteúdo original
        managementContents.style.display = 'block'; // Mostra o conteúdo de gerenciamento
      });
    });