import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["typeSelect", "radioFields", "discursivaFields", "numOptions", "optionsContainer", "gabaritoSelect"]

    connect() {
        this.toggleFields()

        const num = parseInt(this.numOptionsTarget.value) || 0
        if (num > 0) {
            this.updateGabaritoDropdown(num)
        }
    }

    toggleFields() {
        const type = this.typeSelectTarget.value

        if (type === "radio") {
            this.radioFieldsTarget.style.display = "block"
            this.discursivaFieldsTarget.style.display = "none"
        } else if (type === "discursiva") {
            this.radioFieldsTarget.style.display = "none"
            this.discursivaFieldsTarget.style.display = "block"
        } else {
            this.radioFieldsTarget.style.display = "none"
            this.discursivaFieldsTarget.style.display = "none"
        }
    }

    generateOptions() {
        const num = parseInt(this.numOptionsTarget.value) || 0

        this.updateGabaritoDropdown(num)

        this.optionsContainerTarget.innerHTML = ""

        if (num > 0 && num <= 10) {
            const baseName = this.numOptionsTarget.name.replace("[numero_opcoes]", "[opcoes_radio][]")

            for (let i = 0; i < num; i++) {
                const letter = String.fromCharCode(65 + i)

                const wrapper = document.createElement("div")
                wrapper.className = "formulario-field"
                wrapper.style.marginTop = "10px"

                wrapper.innerHTML = `
          <label style="font-size: 0.9rem;">Opção ${letter}</label>
          <input type="text" name="${baseName}" required 
                 style="width: 100%; border: 1px solid var(--gp-line); border-radius: 6px; padding: 8px 12px; box-sizing: border-box;" 
                 placeholder="Digite o texto da opção ${letter}">
        `
                this.optionsContainerTarget.appendChild(wrapper)
            }
        } else if (num > 10) {
            this.optionsContainerTarget.innerHTML = `<span style="color: red;">O máximo de opções permitido é 10.</span>`
        }
    }

    updateGabaritoDropdown(num) {
        const currentSelection = this.gabaritoSelectTarget.value

        this.gabaritoSelectTarget.innerHTML = '<option value="">Selecione a resposta...</option>'

        if (num > 0 && num <= 10) {
            for (let i = 0; i < num; i++) {
                const letter = String.fromCharCode(65 + i)
                const enumValue = `opcao_${letter.toLowerCase()}`

                const option = document.createElement("option")
                option.value = enumValue
                option.textContent = `Opção ${letter}`

                if (currentSelection === enumValue) {
                    option.selected = true
                }
                this.gabaritoSelectTarget.appendChild(option)
            }
        }
    }
}