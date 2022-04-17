import ImportPage from '../../../src/pages/ImportPage.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

const registeredRows = [
  { id: 1, nome: 'D', codigo: 'Dickerson', turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
  { id: 2, nome: 'E', codigo: 'Larsen', turma: 'Shaw', semestre: '2020-1', horario: '2T' },
  { id: 3, nome: 'G', codigo: 'Geneva', turma: 'Wilson', semestre: '2020-1', horario: '2T' },
  { id: 4, nome: 'T', codigo: 'Jami', turma: 'Carney', semestre: '2020-1', horario: '2T' }
]
const registeredFields = [
    {name:'nome', align: 'center', label: 'Nome', field: 'nome'}, 
    {name:'codigo', align: 'center', label: 'Código', field: 'codigo'}, 
    {name:'turma', align: 'center', label: 'Turma', field: 'turma'}, 
    {name:'semestre', align: 'center', label: 'Semestre', field: 'semestre'}, 
    {name:'horario', align: 'center', label: 'Horário', field: 'horario'}
  ]

jest.mock('axios', () => ({
  get: () => {
    return {
      registeredRows
    }
  },
}));

describe('Import Page Tests', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('A página existe', () => {
    const wrapper = mount(ImportPage)
    expect(wrapper).toBeTruthy()
  })

  it('A página possui título', () => {
    const wrapper = mount(ImportPage)
    const header = wrapper.find('Import Page')

    expect(header.exists()).toBe(true)
  })
  
  it('A página possui a tabela de turmas registradas', () => {
    const wrapper = mount(ImportPage)
    const table = wrapper.find('Turmas Registradas')

    expect(table.exists()).toBe(true)

    const headers = wrapper.findAll('th')
    let contador = 0
    registeredFields.forEach( field => {
      expect(headers[contador].text()).toContain(field.label)
      contador++
    })
  })
})
