import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "backdrop", "menuButton"]

  connect() {
    this.expanded = window.innerWidth > 760
    this.updateSidebar()
  }

  toggleSidebar() {
    this.expanded = !this.expanded
    this.updateSidebar()
  }

  closeSidebar() {
    this.expanded = false
    this.updateSidebar()
  }

  closeOnEscape(event) {
    if (event.key !== "Escape" || !this.expanded) return

    this.closeSidebar()
    this.menuButtonTarget.focus()
  }

  updateSidebar() {
    this.element.classList.toggle("sidebar-open", this.expanded)
    this.element.classList.toggle("sidebar-collapsed", !this.expanded)
    this.menuButtonTarget.setAttribute("aria-expanded", this.expanded.toString())
    this.backdropTarget.hidden = !this.expanded
  }
}
