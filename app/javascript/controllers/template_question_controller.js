import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tipo", "opcoes"]

  connect() {
    this.toggleOptions()
  }

  toggleOptions() {
    if (!this.hasTipoTarget || !this.hasOpcoesTarget) return

    this.opcoesTarget.hidden = this.tipoTarget.value !== "objetiva"
  }
}
