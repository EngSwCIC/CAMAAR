import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["target", "template"]

    add(event) {
        event.preventDefault()

        let content = this.templateTarget.innerHTML

        let newId = new Date().getTime()

        content = content.replace(/NEW_RECORD/g, newId)

        this.targetTarget.insertAdjacentHTML('beforeend', content)
    }

    remove(event) {
        event.preventDefault()

        let wrapper = event.target.closest(".nested-fields")

        let destroyField = wrapper.querySelector("input[name*='_destroy']")

        if (destroyField) {
            destroyField.value = "1"
            wrapper.style.display = "none"
        } else {
            wrapper.remove()
        }
    }
}