import { shallowMount } from '@vue/test-utils';
import radioSurvey from 'src/components/surveySelector/radioSurvey';


// Os testes que seguem verificam se:
// Se a componente renderiza corretamente o campo de entrada inicial com um valor vazio.
// Se o método addInput adiciona com sucesso um novo campo de entrada ao clicar no botão "adicionar".
// Se o método removeInput remove com sucesso um campo de entrada existente ao clicar no botão "remover".
// Se o método answer emite com sucesso os dados entrada existente.


describe('radioSurvey', () => {
  it('Data deve ser inicializado como objeto vazio', () => {
    const wrapper = shallowMount(radioSurvey);

    expect(wrapper.vm.data).toEqual([
      {
        key: 1,
        value: "",
      }
    ]);
  });
  it('Função de adição deve adicionar um novo objeto em Data', () => {
    const wrapper = shallowMount(radioSurvey);
    wrapper.vm.addInput();

    expect(wrapper.vm.data).toHaveLength(2);
    expect(wrapper.vm.data[1]).toEqual({
      key: 2,
      value: "",
    });
  });
  it('Função de remover deve retirar objeto de Data', () => {
    const wrapper = shallowMount(radioSurvey);
    wrapper.vm.removeInput(1);

    expect(wrapper.vm.data).toHaveLength(0);
  });
  it('Resposta deve emitir um evento que envie os dados em Data', () => {
    const wrapper = shallowMount(radioSurvey);
    wrapper.vm.answer();

    expect(wrapper.emitted().answer).toBeTruthy();
    expect(wrapper.emitted().answer[0]).toEqual([wrapper.vm.data]);
  });
});


