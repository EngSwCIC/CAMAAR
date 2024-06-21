function mostrar_ocultar() {
    var input_senha = document.getElementById('senha_pass');
    var btn_olho_senha = document.getElementById('olho_senha');

    if (input_senha.type === 'password') {
        input_senha.setAttribute('type', 'text');
        btn_olho_senha.classList.replace('olho_aberto', 'olho_fechado');
        btn_olho_senha.setAttribute('src', '../icons/olho_fechado.svg');
    } else {
        input_senha.setAttribute('type', 'password');
        btn_olho_senha.classList.replace('olho_fechado', 'olho_aberto');
        btn_olho_senha.setAttribute('src', '../icons/olho_aberto.svg');
    }
}

function mostrar_ocultar_r() {
    var input_senha = document.getElementById('redefinir_senha');
    var btn_olho_senha = document.getElementById('olho_senha');

    if (input_senha.type === 'password') {
        input_senha.setAttribute('type', 'text');
        btn_olho_senha.classList.replace('olho_aberto', 'olho_fechado');
        btn_olho_senha.setAttribute('src', '../icons/olho_fechado.svg');
    } else {
        input_senha.setAttribute('type', 'password');
        btn_olho_senha.classList.replace('olho_fechado', 'olho_aberto');
        btn_olho_senha.setAttribute('src', '../icons/olho_aberto.svg');
    }
}

function mostrar_ocultar_r1() {
    var input_senha1 = document.getElementById('confir_redefinir_senha');
    var btn_olho_senha = document.getElementById('olho_senha1');

    if (input_senha1.type === 'password') {
        input_senha1.setAttribute('type', 'text');
        btn_olho_senha.classList.replace('olho_aberto', 'olho_fechado');
        btn_olho_senha.setAttribute('src', '../icons/olho_fechado.svg');
    } else {
        input_senha1.setAttribute('type', 'password');
        btn_olho_senha.classList.replace('olho_fechado', 'olho_aberto');
        btn_olho_senha.setAttribute('src', '../icons/olho_aberto.svg');
    }
}

// essa função não é fixa
function redirecionarPagina() {
    window.location.href = "home.html";
}

document.addEventListener('DOMContentLoaded', () => {

    const popup = document.getElementById('popup');
    const closePopup = document.getElementById('close-popup');

    // Botões do Popup
    const btnImportar = document.getElementById('importar_dados');
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
    };

    // Se clicar fora do popup ele fecha
    window.onclick = function(event) {
        if (event.target == popup) {
            popup.style.display = "none";
        }
    };

    // Condições para habilitar botões
    btnImportar.onclick = function() {
        btnEditar.disabled = false;
    };

    btnEditar.onclick = function() {
        btnEnviar.disabled = false;
    };

    btnEnviar.onclick = function() {
        btnResultados.disabled = false;
    };
});



