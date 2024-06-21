// app/javascript/packs/templates_management.js

document.addEventListener('DOMContentLoaded', function() {
    var btnImportarDados = document.getElementById('btnImportarDados');
    var btnCriarTemplates = document.getElementById('btnCriarTemplates');
    var btnCriarFormularios = document.getElementById('btnCriarFormularios');
    var btnVerResultados = document.getElementById('btnVerResultados');
  
    var importarDadosContent = document.getElementById('ImportarDados');
    var criarTemplatesContent = document.getElementById('CriarTemplates');
    var criarFormulariosContent = document.getElementById('CriarFormularios');
    var verResultadosContent = document.getElementById('VerResultados');
  
    btnImportarDados.addEventListener('click', function() {
      hideAllContents();
      importarDadosContent.style.display = 'block';
    });
  
    btnCriarTemplates.addEventListener('click', function() {
      hideAllContents();
      criarTemplatesContent.style.display = 'block';
    });
  
    btnCriarFormularios.addEventListener('click', function() {
      hideAllContents();
      criarFormulariosContent.style.display = 'block';
    });
  
    btnVerResultados.addEventListener('click', function() {
      hideAllContents();
      verResultadosContent.style.display = 'block';
    });
  
    function hideAllContents() {
      importarDadosContent.style.display = 'none';
      criarTemplatesContent.style.display = 'none';
      criarFormulariosContent.style.display = 'none';
      verResultadosContent.style.display = 'none';
    }
  });
  