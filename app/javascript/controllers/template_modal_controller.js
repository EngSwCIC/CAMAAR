import { Controller } from "@hotwired/stimulus"

// Gerencia os modais de criação, edição e exclusão de templates de formulário
export default class extends Controller {

  openNew() {
    const modal       = document.getElementById("templateModal")
    const form        = document.getElementById("templateForm")
    const methodField = document.getElementById("templateFormMethod")
    const submitBtn   = document.getElementById("templateSubmitBtn")

    form.action          = form.dataset.createUrl || "/admin/templates"
    methodField.value    = "post"
    document.getElementById("templateName").value = ""
    document.getElementById("questoesContainer").innerHTML = this._questaoHtml(0)
    submitBtn.textContent = "Criar"
    this._hideError()

    modal.style.display = "block"
  }

  openEdit(event) {
    const btn       = event.currentTarget
    const id        = btn.dataset.templateId
    const name      = btn.dataset.templateName || ""
    const modal     = document.getElementById("templateModal")
    const form      = document.getElementById("templateForm")
    const submitBtn = document.getElementById("templateSubmitBtn")

    form.action = `/admin/templates/${id}`
    document.getElementById("templateFormMethod").value = "patch"
    document.getElementById("templateName").value = name
    // Limpa questões ao editar — servidor mantém as questões existentes
    document.getElementById("questoesContainer").innerHTML = ""
    submitBtn.textContent = "Criar"
    this._hideError()

    modal.style.display = "block"
  }

  openDelete(event) {
    const btn   = event.currentTarget
    const id    = btn.dataset.templateId
    const name  = btn.dataset.templateName || ""
    const modal = document.getElementById("deleteModal")

    document.getElementById("deleteMessage").textContent =
      `Deseja excluir o template ${name}?`
    document.getElementById("deleteForm").action = `/admin/templates/${id}`

    modal.style.display = "block"
  }

  close() {
    document.getElementById("templateModal").style.display = "none"
  }

  closeDelete() {
    document.getElementById("deleteModal").style.display = "none"
  }

  handleSubmit(event) {
    const name = document.getElementById("templateName").value.trim()

    if (!name) {
      event.preventDefault()
      this._showError("O nome do template é obrigatório")
      return
    }

    const questoes   = document.querySelectorAll("#questoesContainer .questao")
    let hasTextError  = false
    let hasRadioError = false

    questoes.forEach(q => {
      const texto = q.querySelector(".questao-texto").value.trim()
      if (!texto) hasTextError = true

      const tipo = q.querySelector(".questao-tipo").value
      if (tipo === "radio") {
        const opcoes = Array.from(q.querySelectorAll(".campo-opcao"))
          .map(input => input.value.trim())
          .filter(valor => valor.length > 0)
        if (opcoes.length === 0) hasRadioError = true
      }
    })

    if (hasTextError) {
      event.preventDefault()
      this._showError("O texto da questão é obrigatório")
      return
    }

    if (hasRadioError) {
      event.preventDefault()
      this._showError("Questões do tipo Radio devem ter ao menos uma opção")
      return
    }
  }

  addQuestao() {
    const container = document.getElementById("questoesContainer")
    const idx       = container.querySelectorAll(".questao").length
    container.insertAdjacentHTML("beforeend", this._questaoHtml(idx))
  }

  addOpcao(event) {
    const questao = event.currentTarget.closest(".questao")
    const idx     = parseInt(questao.dataset.idx, 10) || 0
    const opcoes  = questao.querySelector(".opcoes-container")
    const count   = opcoes.querySelectorAll(".campo-opcao").length
    const newId   = `questao_${idx}_opcao_${count}`

    const input = document.createElement("input")
    input.type        = "text"
    input.id          = newId
    input.name        = `questions[${idx}][options][]`
    input.className   = "campo-opcao"
    input.placeholder = `Opção ${count + 1}`

    opcoes.insertBefore(input, event.currentTarget)
  }

  _showError(msg) {
    const errDiv = document.getElementById("templateModalError")
    if (errDiv) {
      errDiv.textContent    = msg
      errDiv.style.display  = "block"
    }
  }

  _hideError() {
    const errDiv = document.getElementById("templateModalError")
    if (errDiv) errDiv.style.display = "none"
  }

  _questaoHtml(idx) {
    return `
      <div class="questao" data-idx="${idx}">
        <div class="form-group">
          <label for="questao_${idx}_tipo">Tipo</label>
          <select id="questao_${idx}_tipo" name="questions[${idx}][kind]" class="questao-tipo">
            <option value="radio">Radio</option>
            <option value="text">Texto</option>
          </select>
        </div>
        <div class="form-group">
          <label for="questao_${idx}_texto">Texto</label>
          <input id="questao_${idx}_texto" type="text"
                 name="questions[${idx}][text]" class="questao-texto"
                 placeholder="Texto da questão">
        </div>
        <div class="opcoes-container" data-questao="${idx}">
          <label for="questao_${idx}_opcao_0">Opções</label>
          <input id="questao_${idx}_opcao_0" type="text"
                 name="questions[${idx}][options][]" class="campo-opcao"
                 placeholder="Opção 1">
          <button type="button" class="btn-add-opcao"
                  data-action="click->template-modal#addOpcao">+</button>
        </div>
      </div>`
  }
}
