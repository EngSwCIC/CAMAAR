import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  closeFromOutside(event) {
    if (!this.element.open) return
    if (this.element.contains(event.target)) return

    this.close()
  }

  closeOnEscape(event) {
    if (!this.element.open) return

    event.preventDefault()
    this.close()
    this.summaryElement?.focus()
  }

  close() {
    this.element.open = false
  }

  get summaryElement() {
    return this.element.querySelector("summary")
  }
}
