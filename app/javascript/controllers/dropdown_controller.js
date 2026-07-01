import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["native", "trigger", "label", "menu", "option"]

  connect() {
    this.syncLabel()
    this.close()
  }

  toggle(event) {
    event.preventDefault()

    if (this.menuTarget.hidden) {
      this.open()
    } else {
      this.close()
    }
  }

  close() {
    this.menuTarget.hidden = true
    this.triggerTarget.setAttribute("aria-expanded", "false")
    this.element.classList.remove("is-open")
  }

  open() {
    this.menuTarget.hidden = false
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.element.classList.add("is-open")
  }

  openWithKeyboard(event) {
    event.preventDefault()
    this.open()

    const selected = this.optionTargets.find(
      (option) => option.getAttribute("aria-selected") === "true",
    )
    const optionToFocus = selected || this.optionTargets[0]

    optionToFocus?.focus()
  }

  select(event) {
    event.preventDefault()

    this.nativeTarget.value = event.currentTarget.dataset.dropdownValue
    this.nativeTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this.close()
    this.triggerTarget.focus()
  }

  syncLabel() {
    const selected = this.nativeTarget.selectedOptions[0]
    this.labelTarget.textContent = selected?.textContent || "Tipo de questão"

    this.optionTargets.forEach((option) => {
      const selectedOption = option.dataset.dropdownValue === this.nativeTarget.value
      option.setAttribute("aria-selected", selectedOption.toString())
      option.classList.toggle("is-selected", selectedOption)
    })
  }

  closeFromOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  closeOnEscape(event) {
    if (this.menuTarget.hidden) return

    event.preventDefault()
    this.close()
    this.triggerTarget.focus()
  }

  navigate(event) {
    if (!["ArrowDown", "ArrowUp", "Home", "End"].includes(event.key)) return

    event.preventDefault()
    const currentIndex = this.optionTargets.indexOf(event.target)
    let nextIndex = currentIndex

    if (event.key === "ArrowDown") nextIndex = currentIndex + 1
    if (event.key === "ArrowUp") nextIndex = currentIndex - 1
    if (event.key === "Home") nextIndex = 0
    if (event.key === "End") nextIndex = this.optionTargets.length - 1

    const boundedIndex = Math.max(0, Math.min(nextIndex, this.optionTargets.length - 1))
    this.optionTargets[boundedIndex]?.focus()
  }
}
