import { Controller } from "@hotwired/stimulus"

// Adiciona/remove campos de questão dinamicamente no formulário de template.
export default class extends Controller {
  static targets = ["container", "template", "item"]

  add(event) {
    event.preventDefault()
    // Substitui o índice placeholder por um único para não colidir ids/names
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest("[data-nested-form-target='item']")
    const destroyField = item.querySelector("input[name*='_destroy']")

    if (destroyField) {
      // Registro persistido: marca para destruição e esconde
      destroyField.value = "1"
      item.style.display = "none"
    } else {
      item.remove()
    }
  }
}
