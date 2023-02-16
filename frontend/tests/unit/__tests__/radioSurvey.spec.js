import { shallowMount } from '@vue/test-utils';
import radioSurvey from 'src/components/surveySelector/radioSurvey';

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


