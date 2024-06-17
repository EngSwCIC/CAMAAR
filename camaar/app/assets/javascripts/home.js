document.addEventListener('DOMContentLoaded', () => {
    const subjects = JSON.parse(localStorage.getItem('subjects')) || [];

    const subjectList = document.getElementById('subject-list');
    const addSubjectForm = document.getElementById('add-subject-form');

    const popup = document.getElementById('popup');
    const closePopup = document.getElementById('close-popup');

    // Botões do Popup
    const btnImportar = document.getElementById('importar_dados');
    const btnEditar = document.getElementById('editar_templates');
    const btnEnviar = document.getElementById('enviar_formularios');
    const btnResultados = document.getElementById('resultados');

    const renderSubjects = () => {
        subjectList.innerHTML = '';
        subjects.forEach((subject, index) => {
            const subjectCard = document.createElement('div');
            subjectCard.className = 'subject-card';
            subjectCard.innerHTML = `
                <h3>${subject.name}</h3>
                <p>${subject.semester}</p>
                <p>${subject.professor}</p>
                <button onclick="removeSubject(${index})">Remove</button>
            `;
            subjectList.appendChild(subjectCard);
        });
    };

    addSubjectForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const name = document.getElementById('name').value;
        const semester = document.getElementById('semester').value;
        const professor = document.getElementById('professor').value;

        subjects.push({ name, semester, professor });
        localStorage.setItem('subjects', JSON.stringify(subjects));
        renderSubjects();
        addSubjectForm.reset();
    });

    renderSubjects();

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

function removeSubject(index) {
    const subjects = JSON.parse(localStorage.getItem('subjects')) || [];
    subjects.splice(index, 1);
    localStorage.setItem('subjects', JSON.stringify(subjects));
    document.dispatchEvent(new Event('DOMContentLoaded'));
}
