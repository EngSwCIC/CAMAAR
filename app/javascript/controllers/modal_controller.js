import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "submitButton", "fileInput"]

  open() {
    this.fileInputTargets.forEach(input => (input.value = ""))
    if (this.hasSubmitButtonTarget) this.submitButtonTarget.disabled = true
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  backdropClose(event) {
    if (event.target === this.dialogTarget) {
      this.dialogTarget.close()
    }
  }

  checkFiles() {
    const allFilled = this.fileInputTargets.every(input => input.files.length > 0)
    this.submitButtonTarget.disabled = !allFilled
  }
}
