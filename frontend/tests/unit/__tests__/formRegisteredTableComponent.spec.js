import Table from '../../../src/components/Table.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
import { createTestingPinia } from '@pinia/testing'

installQuasarPlugin();

jest.mock('vue-router', () => ({
  useRouter: () => {
    return { 
      fields: ['nome', 'codigo', 'codigo_da_turma', 'semestre', 'horario'],
      items: [
        { nome: 'D', codigo: 'Dickerson', codigo_da_turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
        { nome: 'E', codigo: 'Larsen', codigo_da_turma: 'Shaw', semestre: '2020-1', horario: '2T' },
        { nome: 'G', codigo: 'Geneva', codigo_da_turma: 'Wilson', semestre: '2020-1', horario: '2T' },
        { nome: 'T', codigo: 'Jami', codigo_da_turma: 'Carney', semestre: '2020-1', horario: '2T' }] 
    }
  },
}));

describe('Registered Classes Component', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });
  it('A tabela existe', () => {
    const wrapper = mount(Table, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })

    expect(wrapper).toContain('b-table')
  })
  it('A tabela possui os cabeçalhos corretos', () => {
    const wrapper = mount(Table, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const table = wrapper.find('b-table')
    table.find(':fields').setValue(fields)

    expect(table.attributes()['fields']).toContain(fields)
  })
})
