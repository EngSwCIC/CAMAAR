document.addEventListener('DOMContentLoaded', function() {
    console.log("JavaScript carregado corretamente!");

    // Adiciona o evento de clique ao botão "Salvar Lista"
    document.getElementById('salvar-lista').addEventListener('click', salvarLista);
});

const nomeListaInput = document.getElementById('nome-lista');
const perguntaInput = document.getElementById('pergunta');
const tipoPerguntaSelect = document.getElementById('tipo-pergunta');
const adicionarPerguntaBtn = document.getElementById('adicionar-pergunta');
const opcoesDinamicas = document.getElementById('opcoes-dinamicas');
const salvarListaBtn = document.getElementById('salvar-lista');
const listasCriadas = document.getElementById('listas-criadas');

const criacaoContainer = document.getElementById('criacao-container');
const edicaoContainer = document.getElementById('edicao-container');
const nomeEdicaoListaInput = document.getElementById('nome-edicao-lista');
const perguntaEdicaoInput = document.getElementById('pergunta-edicao');
const tipoPerguntaEdicaoSelect = document.getElementById('tipo-pergunta-edicao');
const adicionarPerguntaEdicaoBtn = document.getElementById('adicionar-pergunta-edicao');
const opcoesDinamicasEdicao = document.getElementById('opcoes-dinamicas-edicao');
const salvarEdicaoBtn = document.getElementById('salvar-edicao');

let contadorOpcoes = 0;
let perguntas = [];
let editando = false;
let indiceEdicao = -1;

function verificarCamposObrigatorios() {
    const nomeListaPreenchido = nomeListaInput.value.trim() !== '';
    const perguntaPreenchida = perguntaInput.value.trim() !== '';
    const tipoPerguntaSelecionado = tipoPerguntaSelect.value !== '';

    adicionarPerguntaBtn.disabled = !(nomeListaPreenchido && perguntaPreenchida && tipoPerguntaSelecionado);
}

function verificarCamposObrigatoriosEdicao() {
    const nomeListaPreenchido = nomeEdicaoListaInput.value.trim() !== '';
    const perguntaPreenchida = perguntaEdicaoInput.value.trim() !== '';
    const tipoPerguntaSelecionado = tipoPerguntaEdicaoSelect.value !== '';

    adicionarPerguntaEdicaoBtn.disabled = !(nomeListaPreenchido && perguntaPreenchida && tipoPerguntaSelecionado);
}

nomeListaInput.addEventListener('input', verificarCamposObrigatorios);
perguntaInput.addEventListener('input', verificarCamposObrigatorios);
tipoPerguntaSelect.addEventListener('change', verificarCamposObrigatorios);

nomeEdicaoListaInput.addEventListener('input', verificarCamposObrigatoriosEdicao);
perguntaEdicaoInput.addEventListener('input', verificarCamposObrigatoriosEdicao);
tipoPerguntaEdicaoSelect.addEventListener('change', verificarCamposObrigatoriosEdicao);

function adicionarOpcoesDinamicas() {
    opcoesDinamicas.innerHTML = '';

    if (tipoPerguntaSelect.value === 'multipla-escolha') {
        contadorOpcoes = 0; // Reinicia o contador de opções
        adicionarOpcao();

        const adicionarOpcaoBtn = document.createElement('button');
        adicionarOpcaoBtn.textContent = 'Adicionar outra opção';
        adicionarOpcaoBtn.type = 'button';
        adicionarOpcaoBtn.id = 'adicionar-opcao-btn';
        adicionarOpcaoBtn.addEventListener('click', adicionarOpcao);
        opcoesDinamicas.appendChild(adicionarOpcaoBtn);
    } else if (tipoPerguntaSelect.value === 'paragrafo') {
        const opcaoInput = document.createElement('textarea');
        opcoesDinamicas.appendChild(opcaoInput);
    }
}

function adicionarOpcoesDinamicasEdicao() {
    opcoesDinamicasEdicao.innerHTML = '';

    if (tipoPerguntaEdicaoSelect.value === 'multipla-escolha') {
        contadorOpcoes = 0; // Reinicia o contador de opções
        adicionarOpcaoEdicao();

        const adicionarOpcaoBtn = document.createElement('button');
        adicionarOpcaoBtn.textContent = 'Adicionar outra opção';
        adicionarOpcaoBtn.type = 'button';
        adicionarOpcaoBtn.id = 'adicionar-opcao-edicao-btn';
        adicionarOpcaoBtn.addEventListener('click', adicionarOpcaoEdicao);
        opcoesDinamicasEdicao.appendChild(adicionarOpcaoBtn);
    } else if (tipoPerguntaEdicaoSelect.value === 'paragrafo') {
        const opcaoInput = document.createElement('textarea');
        opcoesDinamicasEdicao.appendChild(opcaoInput);
    }
}

function adicionarOpcao() {
    const checkboxContainer = document.createElement('div');
    checkboxContainer.innerHTML = '<label>Opção ' + (contadorOpcoes + 1) + '</label><input type="text" name="opcoes">';
    opcoesDinamicas.insertBefore(checkboxContainer, document.getElementById('adicionar-opcao-btn'));
    contadorOpcoes++;
}

function adicionarOpcaoEdicao() {
    const checkboxContainer = document.createElement('div');
    checkboxContainer.innerHTML = '<label>Opção ' + (contadorOpcoes + 1) + '</label><input type="text" name="opcoes">';
    opcoesDinamicasEdicao.insertBefore(checkboxContainer, document.getElementById('adicionar-opcao-edicao-btn'));
    contadorOpcoes++;
}

function adicionarPergunta() {
    const pergunta = {
        title: perguntaInput.value,
        question_type: tipoPerguntaSelect.value,
        options_attributes: []
    };

    if (pergunta.question_type === 'multipla-escolha') {
        const opcoes = document.querySelectorAll('#opcoes-dinamicas input[type="text"]');
        opcoes.forEach((opcao, index) => {
            pergunta.options_attributes.push({ text: opcao.value });
        });
    }

    perguntas.push(pergunta);
    exibirPerguntas();
    limparCampos();
}

function exibirPerguntas() {
    listasCriadas.innerHTML = '';

    perguntas.forEach((pergunta, index) => {
        const perguntaDiv = document.createElement('div');
        perguntaDiv.classList.add('lista-perguntas');
        perguntaDiv.innerHTML = `<h3>Pergunta ${index + 1}:</h3>
                                 <p>${pergunta.title}</p>`;

        if (pergunta.question_type === 'multipla-escolha') {
            pergunta.options_attributes.forEach((opcao, idx) => {
                perguntaDiv.innerHTML += `${String.fromCharCode(65 + idx)} - ${opcao.text}<br>`;
            });
        } else if (pergunta.question_type === 'paragrafo') {
            perguntaDiv.innerHTML += `Resposta: <textarea disabled>${pergunta.title}</textarea><br>`;
        }

        const editarBtn = document.createElement('button');
        editarBtn.textContent = 'Editar';
        editarBtn.addEventListener('click', () => habilitarEdicao(index));
        perguntaDiv.appendChild(editarBtn);

        const excluirBtn = document.createElement('button');
        excluirBtn.textContent = 'Excluir';
        excluirBtn.addEventListener('click', () => excluirPergunta(index));
        perguntaDiv.appendChild(excluirBtn);

        listasCriadas.appendChild(perguntaDiv);
    });
}

function habilitarEdicao(index) {
    const perguntaTexto = document.getElementById(`pergunta-${index}`);
    perguntaTexto.disabled = !perguntaTexto.disabled;

    if (perguntas[index].question_type === 'multipla-escolha') {
        perguntas[index].options_attributes.forEach((opcao, idx) => {
            const opcaoTexto = document.getElementById(`opcao-${index}-${idx}`);
            opcaoTexto.disabled = !opcaoTexto.disabled;
        });
    } else if (perguntas[index].question_type === 'paragrafo') {
        const respostaTexto = document.getElementById(`resposta-${index}`);
        respostaTexto.disabled = !respostaTexto.disabled;
    }

    const editarBtn = perguntaTexto.nextElementSibling;
    if (perguntaTexto.disabled) {
        editarBtn.textContent = 'Editar';
        editarBtn.classList.remove('salvar-btn'); // Remover classe de salvar
        editarBtn.classList.add('editar-btn'); // Adicionar classe de editar
        editarBtn.style.backgroundColor = ''; // Remove qualquer cor definida anteriormente
    } else {
        editarBtn.textContent = 'Salvar';
        editarBtn.classList.remove('editar-btn'); // Remover classe de editar
        editarBtn.classList.add('salvar-btn'); // Adicionar classe de salvar
        editarBtn.style.backgroundColor = 'green'; // Define a cor verde para o botão
    }

    editando = !perguntaTexto.disabled; // Atualizar o status de edição global
    indiceEdicao = perguntaTexto.disabled ? -1 : index; // Atualizar o índice de edição global
}

function excluirPergunta(index) {
    perguntas.splice(index, 1);
    exibirPerguntas();
}

function limparCampos() {
    perguntaInput.value = '';
    tipoPerguntaSelect.value = '';
    opcoesDinamicas.innerHTML = '';
    adicionarPerguntaBtn.disabled = true;
}

function adicionarPerguntaEdicao() {
    const pergunta = {
        title: perguntaEdicaoInput.value,
        question_type: tipoPerguntaEdicaoSelect.value,
        options_attributes: []
    };

    if (pergunta.question_type === 'multipla-escolha') {
        const opcoes = document.querySelectorAll('#opcoes-dinamicas-edicao input[type="text"]');
        opcoes.forEach((opcao, index) => {
            pergunta.options_attributes.push({ text: opcao.value });
        });
    }

    perguntas[indiceEdicao] = pergunta;
    exibirPerguntas();
    limparCamposEdicao();
}

function limparCamposEdicao() {
    nomeEdicaoListaInput.value = '';
    perguntaEdicaoInput.value = '';
    tipoPerguntaEdicaoSelect.value = '';
    opcoesDinamicasEdicao.innerHTML = '';
    salvarEdicaoBtn.disabled = true;
    edicaoContainer.classList.add('hidden');
    criacaoContainer.classList.remove('hidden');
    editando = false;
    indiceEdicao = -1;
}

// Event listeners
adicionarPerguntaBtn.addEventListener('click', adicionarPergunta);
adicionarPerguntaEdicaoBtn.addEventListener('click', adicionarPerguntaEdicao);
salvarListaBtn.addEventListener('click', () => {
    if (perguntas.length > 0) {
        const listaPerguntas = {
            survey: {
                title: nomeListaInput.value,
                questions_attributes: perguntas.map(pergunta => ({
                    title: pergunta.texto,
                    question_type: pergunta.tipo,
                    options_attributes: pergunta.opcoes.map(opcao => ({ text: opcao.texto }))
                }))
            }
        };

        fetch('/surveys', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify(listaPerguntas)
        })
            .then(response => response.json())
            .then(data => {
                console.log("Lista de perguntas salva:", data);
                perguntas = [];
                listasCriadas.innerHTML = '';
                alert('Lista de perguntas salva com sucesso!');
            })
            .catch(error => {
                console.error('Erro ao salvar lista de perguntas:', error);
                alert('Ocorreu um erro ao salvar a lista de perguntas.');
            });
    } else {
        alert('Adicione pelo menos uma pergunta antes de salvar.');
    }
});

tipoPerguntaSelect.addEventListener('change', adicionarOpcoesDinamicas);
tipoPerguntaEdicaoSelect.addEventListener('change', adicionarOpcoesDinamicasEdicao);

document.getElementById('carregar-surveys').addEventListener('click', () => {
    fetch('/surveys')
        .then(response => response.json())
        .then(data => {
            const surveysList = document.getElementById('surveys-list');
            surveysList.innerHTML = '';

            data.forEach(survey => {
                const surveyDiv = document.createElement('div');
                surveyDiv.innerHTML = `<h3>${survey.title}</h3>`;

                survey.questions.forEach(question => {
                    const questionDiv = document.createElement('div');
                    questionDiv.innerHTML = `<p>${question.title} (${question.question_type})</p>`;

                    if (question.question_type === 'multipla-escolha') {
                        question.options.forEach(option => {
                            questionDiv.innerHTML += `<p>${option.text}</p>`;
                        });
                    }

                    surveyDiv.appendChild(questionDiv);
                });

                surveysList.appendChild(surveyDiv);
            });
        })
        .catch(error => {
            console.error('Erro ao carregar surveys:', error);
            alert('Ocorreu um erro ao carregar as surveys.');
        });
});
