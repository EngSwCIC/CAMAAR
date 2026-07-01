import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["questions", "questionTemplate", "optionTemplate"]

  connect() {
    this.renumberAll()
  }

  addQuestion(event) {
    event.preventDefault()

    const questionIndex = this.uniqueIndex()
    const fragment = this.htmlToFragment(
      this.questionTemplateTarget.innerHTML.replaceAll(
        "NEW_QUESTION",
        questionIndex,
      ),
    )
    const question = fragment.querySelector("[data-template-form-question]")

    question.dataset.templateFormQuestionIndex = questionIndex
    this.questionsTarget.append(fragment)
    this.renumberAll()
  }

  addOption(event) {
    event.preventDefault()

    const question = event.target.closest("[data-template-form-question]")
    if (!question) return

    this.appendOption(question)
    this.renumberOptions(question)
  }

  ensureObjectiveOptions(event) {
    const question = event.target.closest("[data-template-form-question]")
    if (!question || event.target.value !== "objetiva") return

    const missingOptions = Math.max(0, 2 - this.optionElements(question).length)

    for (let index = 0; index < missingOptions; index += 1) {
      this.appendOption(question)
    }

    this.renumberOptions(question)
  }

  appendOption(question) {
    const optionIndex = this.uniqueIndex()
    const questionIndex = question.dataset.templateFormQuestionIndex
    const fragment = this.htmlToFragment(
      this.optionTemplateTarget.innerHTML
        .replaceAll("NEW_QUESTION", questionIndex)
        .replaceAll("NEW_OPTION", optionIndex),
    )
    question.querySelector("[data-template-form-options]").append(fragment)
  }

  moveQuestionUp(event) {
    event.preventDefault()

    const question = event.target.closest("[data-template-form-question]")
    if (!question) return

    this.moveElementUp(question)
    this.renumberAll()
  }

  moveQuestionDown(event) {
    event.preventDefault()

    const question = event.target.closest("[data-template-form-question]")
    if (!question) return

    this.moveElementDown(question)
    this.renumberAll()
  }

  moveOptionUp(event) {
    event.preventDefault()

    const option = event.target.closest("[data-template-form-option]")
    const question = event.target.closest("[data-template-form-question]")
    if (!option || !question) return

    this.moveElementUp(option)
    this.renumberOptions(question)
  }

  moveOptionDown(event) {
    event.preventDefault()

    const option = event.target.closest("[data-template-form-option]")
    const question = event.target.closest("[data-template-form-question]")
    if (!option || !question) return

    this.moveElementDown(option)
    this.renumberOptions(question)
  }

  destroyQuestion(event) {
    event.preventDefault()

    const question = event.target.closest("[data-template-form-question]")
    if (!question) return

    const idField = question.querySelector("[data-template-form-utilizacao-id]")
    const destroyField = question.querySelector("[data-template-form-question-destroy]")

    if (!idField?.value) {
      question.remove()
      this.renumberAll()
      return
    }

    destroyField.value = "1"
    question.hidden = true
    question.style.display = "none"
    this.renumberAll()
  }

  destroyOption(event) {
    event.preventDefault()

    const option = event.target.closest("[data-template-form-option]")
    const question = event.target.closest("[data-template-form-question]")
    if (!option || !question) return

    const optionIdField = option.querySelector("[data-template-form-opcao-id]")
    const destroyField = option.querySelector("[data-template-form-option-destroy]")

    if (!optionIdField?.value) {
      option.remove()
      this.renumberOptions(question)
      return
    }

    destroyField.value = "1"
    option.hidden = true
    option.style.display = "none"
    this.renumberOptions(question)
  }

  uniqueIndex() {
    if (!this.index) this.index = Date.now()

    this.index += 1
    return this.index.toString()
  }

  htmlToFragment(html) {
    const template = document.createElement("template")
    template.innerHTML = html.trim()

    return template.content
  }

  moveElementUp(element) {
    const previous = element.previousElementSibling
    if (!previous) return

    previous.before(element)
  }

  moveElementDown(element) {
    const next = element.nextElementSibling
    if (!next) return

    next.after(element)
  }

  renumberAll() {
    this.questionElements.forEach((question, index) => {
      const number = index + 1

      question.querySelector("[data-template-form-question-number]").value = number
      question.querySelector("[data-template-form-question-position]").textContent =
        number
      this.renumberOptions(question)
    })
  }

  renumberOptions(question) {
    this.optionElements(question).forEach((option, index) => {
      const number = index + 1

      option.querySelector("[data-template-form-option-number]").value = number
      option.querySelector("[data-template-form-option-position]").textContent =
        this.optionLetter(number)

      const textField = option.querySelector("[data-template-form-option-text]")
      if (textField) textField.placeholder = `Opção ${number}`
    })
  }

  optionLetter(number) {
    let result = ""
    let current = number

    while (current > 0) {
      current -= 1
      result = String.fromCharCode(97 + (current % 26)) + result
      current = Math.floor(current / 26)
    }

    return result
  }

  get questionElements() {
    return [...this.questionsTarget.children].filter((element) =>
      element.matches("[data-template-form-question]") && !element.hidden,
    )
  }

  optionElements(question) {
    const options = question.querySelector("[data-template-form-options]")
    if (!options) return []

    return [...options.children].filter((element) =>
      element.matches("[data-template-form-option]") && !element.hidden,
    )
  }
}
