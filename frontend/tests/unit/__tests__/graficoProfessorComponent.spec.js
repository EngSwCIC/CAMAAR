import Professor from '../../../src/components/GraficoProfessor.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

// const $axios = {
//   get: (url) => {
//     return {data: {rows: registeredRows}}
//   }
// }

test('testar se os dados estão sendo carregados corretamente',  () => {
    const wrapper = mount(Professor, {
        data() {
        }
    })
    expect(wrapper.data().um).toBe(null)
    // expect(Professor.dois).not.toBe(null)
    // expect(Professor.tres).not.toBe(null)
    // expect(Professor.quatro).not.toBe(null)
    // expect(Professor.cinco).not.toBe(null)
})


