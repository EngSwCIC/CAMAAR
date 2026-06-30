import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    document.body.classList.toggle("sidebar-collapsed")
  }
}
