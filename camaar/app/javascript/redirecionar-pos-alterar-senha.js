document.addEventListener('DOMContentLoaded', function() {
    var submitButton = document.getElementById('submit-button');
  
    if (submitButton) {
      submitButton.addEventListener('click', function(event) {
        var role = "<%= current_user.role %>";
        var homeDicentePath = "<%= home_dicente_path %>";
        var homeDocentePath = "<%= home_docente_path %>";
  
        if (role === 'dicente') {
          window.location.href = homeDicentePath;
        } else if (role === 'docente') {
          window.location.href = homeDocentePath;
        }
        // Adicione mais lógica conforme necessário
      });
    }
  });