document.addEventListener('DOMContentLoaded', () => {

    const popup = document.getElementById('popup');
    const closePopup = document.getElementById('close-popup');
    const popupUpload = document.getElementById('popup-upload'); // Novo popup de upload
    const closePopupUpload = document.getElementById('close-popup-upload'); // Botão de fechar do novo popup

    // Botões do Popup
    const btnImportar = document.getElementById('importar_dados_btn');
    const btnEditar = document.getElementById('editar_templates');
    const btnEnviar = document.getElementById('enviar_formularios');
    const btnResultados = document.getElementById('resultados');

    document.getElementById("menu-icon").onclick = function() {
        const sidebar = document.getElementById("sidebar");
        if (sidebar.style.width === "0px" || sidebar.style.width === "") {
            sidebar.style.width = "250px";
        } else {
            sidebar.style.width = "0";
        }
    };

    document.getElementById("gerenciamento-btn").onclick = function() {
        document.getElementById("title").textContent = "Gerenciamento";
        popup.style.display = "block"; // Abre popup
    };

    document.getElementById("avaliacoes-btn").onclick = function() {
        document.getElementById("title").textContent = "Avaliações";
    };

    // Ação do X de fechar o popup
    closePopup.onclick = function() {
        popup.style.display = "none";
        popup.classList.remove('popup-color'); // Remove a classe de cor do popup principal
    };

    // Ação do X de fechar o popup de upload
    closePopupUpload.onclick = function() {
        popupUpload.style.display = "none";
    };

    // Se clicar fora do popup ele fecha
    window.onclick = function(event) {
        if (event.target == popup) {
            popup.style.display = "none";
        }
        if (event.target == popupUpload) {
            popupUpload.style.display = "none";
        }
    };

    // Evento para abrir o popup de upload ao clicar em "Importar Dados"
    btnImportar.onclick = function() {
        event.preventDefault(); // Impede o comportamento padrão do link/button
        popup.classList.add('popup-color'); // Adiciona a classe de cor ao popup principal
        popup.style.display = "none"; // Fecha o popup atual, se estiver aberto
        console.log("fechou o popup")
        popupUpload.style.display = "block"; // Abre o popup de upload
    };

    // Condições para habilitar botões
    btnEditar.onclick = function() {
        btnEnviar.disabled = false;
    };

    btnEnviar.onclick = function() {
        btnResultados.disabled = false;
    };
});
