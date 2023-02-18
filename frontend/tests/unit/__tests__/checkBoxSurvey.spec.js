import { shallowMount } from "@vue/test-utils";
import checkBoxSurvey from "src/components/surveySelector/checkBoxSurvey.vue";

// Os testes que seguem verificam se:
// Se a componente renderiza corretamente o campo de entrada inicial com um valor vazio.
// Se o método addInput adiciona com sucesso um novo campo de entrada ao clicar no botão "adicionar".
// Se o método removeInput remove com sucesso um campo de entrada existente ao clicar no botão "remover".


describe("checkBoxSurvey", () => {
  it("teste valor vazio", () => {
    const wrapper = shallowMount(checkBoxSurvey);
    const [_, input] = wrapper.findAll("input");
    expect(input.exists()).toBe(true);
    expect(input.element.value).toBe("");
  });

  it("testando metodo addInput", async () => {
    const wrapper = shallowMount(checkBoxSurvey);
    const addButton = wrapper.findAll("q-btn").at(1);
    await addButton.trigger("click");
    const inputs = wrapper.findAll("input");
    expect(inputs.length).toBe(4);
  });

  it("testando metodo removeInput", async () => {
    const wrapper = shallowMount(checkBoxSurvey, {
      data() {
        return {
          data: [
            { key: 1, value: "" },
            { key: 2, value: "" },
            { key: 3, value: "joao" }
          ]
        };
      }
    });
    const removeButton = wrapper.findAll("q-btn").at(0);
    const inputs = wrapper.findAll("input");
    expect(inputs.length).toBe(6);
    await removeButton.trigger("click");
    const inputsAfterClick = wrapper.findAll("input");
    expect(inputsAfterClick.length).toBe(4);
  });
});

