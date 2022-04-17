import GenericTable from '../../../src/components/GenericTable.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

const fields = [
  {name:'nome', align: 'center', label: 'Nome', field: 'nome'}, 
  {name:'codigo', align: 'center', label: 'Código', field: 'codigo'}, 
  {name:'turma', align: 'center', label: 'Turma', field: 'turma'}, 
  {name:'semestre', align: 'center', label: 'Semestre', field: 'semestre'}, 
  {name:'horario', align: 'center', label: 'Horário', field: 'horario'}
]
const rows = [
  { id: 1, nome: 'D', codigo: 'Dickerson', turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
  { id: 2, nome: 'E', codigo: 'Larsen', turma: 'Shaw', semestre: '2020-1', horario: '2T' },
  { id: 3, nome: 'G', codigo: 'Geneva', turma: 'Wilson', semestre: '2020-1', horario: '2T' },
  { id: 4, nome: 'T', codigo: 'Jami', turma: 'Carney', semestre: '2020-1', horario: '2T' }
] 
// jest.mock('axios', () => ({
//   get: () => {
//     return {
//       rows
//     }
//   },
// }));
describe('Table of Registered Classes Tests', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('A tabela existe', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields: [], rows: []}
    })
    const table = wrapper.find('#table')

    expect(table.exists()).toBe(true)
  })

  it('A tabela possui a quantidade certa de cabeçalhos', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields: fields, rows: rows}
    })
    const headers = wrapper.findAll('th')
    expect(headers.length).toBe(fields.length)
  })
  
  it('A tabela possui os cabeçalhos corretos', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields: fields, rows: rows}
    })
    const headers = wrapper.findAll('th')
    let contador = 0
    fields.forEach( field => {
      expect(headers[contador].text()).toContain(field.label)
      contador++
    })
  })
})
