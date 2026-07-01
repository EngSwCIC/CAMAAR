import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["input", "results", "filterButton", "filterMenu", "turmaIdField", "semTemplatesField"]
  static values = { url: String }

  connect() {
    this.activeIndex = -1
    this.timeout = null
    this.initialTermo = this.inputTarget.value
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  query() {
    this.clearScopeIfEdited()

    const termo = this.inputTarget.value.trim()
    clearTimeout(this.timeout)

    if (termo.length === 0) {
      this.closeResults()
      return
    }

    this.timeout = setTimeout(() => this.buscar(termo), 250)
  }

  // Se o usuário veio de uma sugestão de Matéria/Turma (escopo "sem templates")
  // mas decide digitar um termo novo, o escopo antigo deixa de fazer sentido:
  // removemos os campos ocultos e reabilitamos o checkbox de Templates.
  clearScopeIfEdited() {
    if (this.inputTarget.value === this.initialTermo) return

    if (this.hasTurmaIdFieldTarget) this.turmaIdFieldTarget.remove()
    if (this.hasSemTemplatesFieldTarget) this.semTemplatesFieldTarget.remove()

    if (this.hasFilterMenuTarget) {
      const templatesCheckbox = this.filterMenuTarget.querySelector('input[value="templates"]')
      if (templatesCheckbox && templatesCheckbox.disabled) {
        templatesCheckbox.disabled = false
        templatesCheckbox.checked = true
        templatesCheckbox.closest("label")?.classList.remove("is-disabled")
      }
    }
  }

  async buscar(termo) {
    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("q", termo)

    if (this.hasFilterMenuTarget) {
      url.searchParams.set("filtro_ativo", "1")
      this.filterMenuTarget.querySelectorAll('input[type="checkbox"]:checked').forEach((checkbox) => {
        url.searchParams.append("tipos[]", checkbox.value)
      })
    }

    try {
      const response = await fetch(url, { headers: { Accept: "application/json" } })

      if (!response.ok) {
        this.closeResults()
        return
      }

      const sugestoes = await response.json()
      this.renderResults(sugestoes)
    } catch (erro) {
      console.error("Falha ao buscar sugestões:", erro)
      this.closeResults()
    }
  }

  renderResults(sugestoes) {
    this.activeIndex = -1

    if (sugestoes.length === 0) {
      this.closeResults()
      return
    }

    this.resultsTarget.innerHTML = sugestoes
      .map((sugestao, index) => `
        <button type="button" class="search-suggestion" data-index="${index}" data-url="${sugestao.url}"
                data-action="click->search#select mouseenter->search#highlight">
          <span class="search-suggestion__tipo">${sugestao.tipo}</span>
          <span class="search-suggestion__texto">
            <strong>${this.escapeHtml(sugestao.titulo)}</strong>
            ${sugestao.subtitulo ? `<small>${this.escapeHtml(sugestao.subtitulo)}</small>` : ""}
          </span>
          ${this.renderMeta(sugestao)}
        </button>
      `)
      .join("")

    this.openResults()
  }

  renderMeta(sugestao) {
    if (!sugestao.materia_codigo) return ""

    const turmaHtml = sugestao.turma_codigo
      ? `<small class="search-suggestion__turma">Turma ${this.escapeHtml(sugestao.turma_codigo)}</small>`
      : ""

    return `
      <span class="search-suggestion__meta">
        <span class="search-suggestion__codigo">${this.escapeHtml(sugestao.materia_codigo)}</span>
        ${turmaHtml}
      </span>
    `
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text || ""
    return div.innerHTML
  }

  openResults() {
    this.resultsTarget.hidden = false
  }

  closeResults() {
    this.resultsTarget.hidden = true
    this.resultsTarget.innerHTML = ""
    this.activeIndex = -1
  }

  toggleFilter() {
    const vaiAbrir = this.filterMenuTarget.hidden
    this.filterMenuTarget.hidden = !vaiAbrir
    this.filterButtonTarget.classList.toggle("is-active", vaiAbrir)

    if (vaiAbrir) this.closeResults()
  }

  closeFilterMenu() {
    if (!this.hasFilterMenuTarget) return

    this.filterMenuTarget.hidden = true
    this.filterButtonTarget.classList.remove("is-active")
  }

  navigate(event) {
    if (event.key === "Escape") {
      this.closeResults()
      this.closeFilterMenu()
      return
    }

    if (this.resultsTarget.hidden) return

    const itens = Array.from(this.resultsTarget.querySelectorAll(".search-suggestion"))
    if (itens.length === 0) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.activeIndex = this.activeIndex < itens.length - 1 ? this.activeIndex + 1 : -1
      this.updateHighlight(itens)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.activeIndex = this.activeIndex > -1 ? this.activeIndex - 1 : itens.length - 1
      this.updateHighlight(itens)
    } else if (event.key === "Enter") {
      if (this.activeIndex >= 0) {
        event.preventDefault()
        this.goTo(itens[this.activeIndex].dataset.url)
      }
    }
  }

  updateHighlight(itens) {
    itens.forEach((item, index) => {
      item.classList.toggle("is-active", index === this.activeIndex)
    })
    itens[this.activeIndex]?.scrollIntoView({ block: "nearest" })
  }

  highlight(event) {
    const itens = Array.from(this.resultsTarget.querySelectorAll(".search-suggestion"))
    this.activeIndex = Number(event.currentTarget.dataset.index)
    this.updateHighlight(itens)
  }

  select(event) {
    this.goTo(event.currentTarget.dataset.url)
  }

  goTo(url) {
    this.closeResults()
    this.closeFilterMenu()
    Turbo.visit(url)
  }

  closeIfOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeResults()
      this.closeFilterMenu()
    }
  }
}