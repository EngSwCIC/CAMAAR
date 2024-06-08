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
