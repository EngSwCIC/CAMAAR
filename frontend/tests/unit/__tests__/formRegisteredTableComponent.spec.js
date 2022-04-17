import Table from '../../../src/components/Table.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'

installQuasarPlugin();

const fields = ['nome', 'codigo', 'codigo_da_turma', 'semestre', 'horario']
const items = [
                { id: 1, nome: 'D', codigo: 'Dickerson', codigo_da_turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
                { id: 2, nome: 'E', codigo: 'Larsen', codigo_da_turma: 'Shaw', semestre: '2020-1', horario: '2T' },
                { id: 3, nome: 'G', codigo: 'Geneva', codigo_da_turma: 'Wilson', semestre: '2020-1', horario: '2T' },
                { id: 4, nome: 'T', codigo: 'Jami', codigo_da_turma: 'Carney', semestre: '2020-1', horario: '2T' }
              ] 

describe('Registered Classes Component', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('A tabela existe', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields: [], items: []}
    })
    const table = wrapper.find('#table')

    expect(table.attributes())
  })

  it('A tabela possui os cabeçalhos corretos', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields, items}
    })

    const table = wrapper.find('#table')
    console.log(table)
    expect(table.attributes()['columns']).toContain(fields)
  })
})
