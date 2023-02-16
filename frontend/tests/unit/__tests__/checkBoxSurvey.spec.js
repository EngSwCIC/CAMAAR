import { shallowMount } from "@vue/test-utils";
import checkBoxSurvey from "src/components/surveySelector/checkBoxSurvey.vue";


describe('checkBoxSurvey', () => {
  it('teste valor vazio', () => {
    const wrapper = shallowMount(checkBoxSurvey)
    const input = wrapper.find('input')
    expect(input.exists()).toBe(true)
    expect(input.element.value).toBe('')
  })

  it('testando metodo addInput', async () => {
    const wrapper = shallowMount(checkBoxSurvey)
    const addButton = wrapper.find('button')
    await addButton.trigger('click')
    const inputs = wrapper.findAll('input')
    expect(inputs.length).toBe(2)
    expect(inputs[1].element.value).toBe('')
  })

  it('testando metodo removeInput', async () => {
    const wrapper = shallowMount(checkBoxSurvey, {
      data() {
        return {
          data: [
            { key: 1, value: '' },
            { key: 2, value: '' },
            { key: 3, value: '' }
          ]
        }
      }
    })
    const removeButton = wrapper.findAll('button').at(1)
    await removeButton.trigger('click')
    const inputs = wrapper.findAll('input')
    expect(inputs.length).toBe(2)
    expect(inputs[1].element.value).toBe('')
  })

  it('testando metodo answer', () => {
    const wrapper = shallowMount(checkBoxSurvey)
    const spy = jest.spyOn(wrapper.vm, '$emit')
    wrapper.vm.answer()
    expect(spy).toHaveBeenCalledWith('answer', [{ key: 1, value: '' }])
  })
})

// Esses testes verificam se:

// Se a componente renderiza corretamente o campo de entrada inicial com um valor vazio.
// Se o método addInput adiciona com sucesso um novo campo de entrada ao clicar no botão "adicionar".
// Se o método removeInput remove com sucesso um campo de entrada existente ao clicar no botão "remover".
// Se o método answer emite um evento 'answer' com os dados atualizados quando um campo de entrada é adicionado ou removido.


