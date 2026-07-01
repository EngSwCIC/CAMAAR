import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "button",
    "menu",
    "filterItem",
    "classCard",
    "emptyState",
    "label",
    "list",
    "searchInput",
    "section",
    "sectionEmpty",
  ]
  static values = {
    selectedMateriaIds: String,
    selectedProfessorIds: String,
  }

  connect() {
    if (!this.hasMenuTarget || !this.hasButtonTarget) return

    this.observeListSize()
    this.applyFilter()
    this.close({ animated: false })
  }

  disconnect() {
    window.clearTimeout(this.closeTimer)
    this.listResizeObserver?.disconnect()
  }

  toggle(event) {
    event.preventDefault()
    if (!this.hasMenuTarget) return

    if (this.menuTarget.hidden || !this.menuTarget.classList.contains("is-open")) {
      this.open()
    } else {
      this.close()
    }
  }

  filter(event) {
    event.preventDefault()

    const item = event.currentTarget
    const filterType = item.dataset.filterType
    const filterValue = item.dataset.filterValue || ""

    if (item.dataset.filterDefault === "true") {
      this.setSelectedValuesFor(filterType, [])
    } else if (filterValue !== "") {
      this.toggleSelectedValue(filterType, filterValue)
    }

    this.applyFilter()
  }

  open() {
    if (!this.hasMenuTarget || !this.hasButtonTarget) return

    window.clearTimeout(this.closeTimer)
    this.collapseSections()
    this.resetSearches()
    this.menuTarget.hidden = false
    this.menuTarget.classList.remove("is-closing")
    this.element.classList.add("is-filter-open")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    this.buttonTarget.setAttribute("aria-label", "Fechar filtros")
    this.buttonTarget.setAttribute("title", "Fechar filtros")
    this.buttonTarget.classList.add("is-active")

    requestAnimationFrame(() => {
      this.menuTarget.classList.add("is-open")
      this.syncMenuHeight()
    })
  }

  close({ animated = true } = {}) {
    if (!this.hasMenuTarget || !this.hasButtonTarget) return

    window.clearTimeout(this.closeTimer)
    this.element.classList.remove("is-filter-open")
    this.buttonTarget.setAttribute("aria-expanded", "false")
    this.buttonTarget.setAttribute("aria-label", "Filtrar turmas")
    this.buttonTarget.setAttribute("title", "Filtrar turmas")
    this.buttonTarget.classList.remove("is-active")

    if (this.menuTarget.hidden) return

    this.menuTarget.classList.remove("is-open")

    if (!animated) {
      this.menuTarget.hidden = true
      return
    }

    this.menuTarget.classList.add("is-closing")
    this.closeTimer = window.setTimeout(() => {
      if (this.menuTarget.classList.contains("is-open")) return

      this.menuTarget.hidden = true
      this.menuTarget.classList.remove("is-closing")
    }, 320)
  }

  closeFromOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  closeOnEscape(event) {
    if (!this.hasMenuTarget) return
    if (this.menuTarget.hidden) return

    event.preventDefault()
    this.close()
    this.buttonTarget.focus()
  }

  applyFilter() {
    const selectedMateriaIds = this.selectedValuesFor("materia")
    const selectedProfessorIds = this.selectedValuesFor("professor")
    let visibleCards = 0

    this.classCardTargets.forEach((card) => {
      const materiaMatches = selectedMateriaIds.length === 0 || selectedMateriaIds.includes(card.dataset.materiaId)
      const professorIds = (card.dataset.professorIds || "").split(" ").filter(Boolean)
      const professorMatches = selectedProfessorIds.length === 0 ||
        professorIds.some((professorId) => selectedProfessorIds.includes(professorId))
      const visible = materiaMatches && professorMatches

      card.hidden = !visible
      if (visible) visibleCards += 1
    })

    this.filterItemTargets.forEach((item) => {
      const selectedValues = this.selectedValuesFor(item.dataset.filterType)
      const itemValue = item.dataset.filterValue || ""
      const selected = item.dataset.filterDefault === "true" ?
        selectedValues.length === 0 :
        selectedValues.includes(itemValue)

      item.classList.toggle("is-selected", selected)
      item.setAttribute("aria-checked", selected.toString())
    })

    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.hidden = visibleCards > 0
    }

    this.updateLabel()
    requestAnimationFrame(() => this.syncMenuHeight())
  }

  searchOptions(event) {
    const scope = event.currentTarget.dataset.filterScope
    const query = this.normalize(event.currentTarget.value)
    let visibleItems = 0

    this.filterItemTargets.forEach((item) => {
      if (item.dataset.filterScope !== scope) return

      const visible = item.dataset.filterDefault === "true" || this.normalize(item.dataset.filterText).includes(query)
      item.hidden = !visible
      if (visible && item.dataset.filterDefault !== "true") visibleItems += 1
    })

    this.sectionEmptyTargets.forEach((emptyState) => {
      if (emptyState.dataset.filterScope !== scope) return

      emptyState.hidden = visibleItems > 0 || query.length === 0
    })
  }

  toggleSelectedValue(filterType, value) {
    const selectedValues = this.selectedValuesFor(filterType)
    const valueIndex = selectedValues.indexOf(value)

    if (valueIndex >= 0) {
      selectedValues.splice(valueIndex, 1)
    } else {
      selectedValues.push(value)
    }

    this.setSelectedValuesFor(filterType, selectedValues)
  }

  selectedValuesFor(filterType) {
    const selectedValues = this.selectedValuesStringFor(filterType)
    return selectedValues.split(" ").filter(Boolean)
  }

  selectedValuesStringFor(filterType) {
    if (filterType === "materia") return this.selectedMateriaIdsValue || ""
    if (filterType === "professor") return this.selectedProfessorIdsValue || ""

    return ""
  }

  setSelectedValuesFor(filterType, selectedValues) {
    const selectedValuesString = selectedValues.join(" ")

    if (filterType === "materia") {
      this.selectedMateriaIdsValue = selectedValuesString
    } else if (filterType === "professor") {
      this.selectedProfessorIdsValue = selectedValuesString
    }
  }

  updateLabel() {
    if (!this.hasLabelTarget) return

    const materiaLabel = this.summaryLabelFor("materia", "Todas as matérias", "matérias")
    const professorLabel = this.summaryLabelFor("professor", "Todos professores", "professores")

    this.labelTarget.textContent = `${materiaLabel} · ${professorLabel}`
  }

  summaryLabelFor(filterType, defaultLabel, pluralLabel) {
    const selectedValues = this.selectedValuesFor(filterType)

    if (selectedValues.length === 0) return defaultLabel
    if (selectedValues.length === 1) return this.labelFor(filterType, selectedValues[0])

    return `${selectedValues.length} ${pluralLabel}`
  }

  labelFor(filterType, selectedValue) {
    const selectedItem = this.filterItemTargets.find(
      (item) => item.dataset.filterType === filterType && (item.dataset.filterValue || "") === selectedValue,
    )

    if (selectedItem) return selectedItem.dataset.filterLabel

    return filterType === "materia" ? "Todas as matérias" : "Todos professores"
  }

  collapseSections() {
    this.sectionTargets.forEach((section) => {
      section.open = false
    })
  }

  resetSearches() {
    this.searchInputTargets.forEach((input) => {
      input.value = ""
    })

    this.filterItemTargets.forEach((item) => {
      item.hidden = false
    })

    this.sectionEmptyTargets.forEach((emptyState) => {
      emptyState.hidden = true
    })
  }

  observeListSize() {
    if (!this.hasListTarget || typeof ResizeObserver === "undefined") return

    this.listResizeObserver = new ResizeObserver(() => this.syncMenuHeight())
    this.listResizeObserver.observe(this.listTarget)
  }

  syncMenuHeight() {
    if (!this.hasListTarget) return

    const listHeight = Math.ceil(this.listTarget.getBoundingClientRect().height)
    this.menuTarget.style.setProperty(
      "--class-filter-panel-height",
      `${Math.max(listHeight, 112)}px`,
    )
  }

  normalize(value) {
    return (value || "")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
  }
}
