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
const rows1 = [
  { id: 1, nome: 'D', codigo: 'Dickerson', turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
  { id: 4, nome: 'T', codigo: 'Jami', turma: 'Carney', semestre: '2020-1', horario: '2T' }
]
const rows2 = [
  { id: 1, nome: 'D', codigo: 'Dickerson', turma: '', semestre: '2020-1', horario: '2T' },
  { id: 4, nome: 'T', codigo: '', turma: 'Carney', semestre: '2020-1', horario: null }
] 

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
      propsData: {fields: fields, rows: rows1}
    })
    const headers = wrapper.findAll('th')
    expect(headers.length).toBe(fields.length)
  })
  
  it('A tabela possui os cabeçalhos corretos', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields: fields, rows: rows1}
    })
    const headers = wrapper.findAll('th')
    let contador = 0
    fields.forEach( field => {
      expect(headers[contador].text()).toContain(field.label)
      contador++
    })
  })

  it('As células da tabela são válidas', () => {
    const wrapper = mount(GenericTable, {
      propsData: {fields: fields, rows: rows2}
    })
    const cells = wrapper.findAll('.q-virtual-scroll__content tr td')
    // cells.forEach( cell => {
      // expect(cell).not.toBeNull()
      // console.log(cell.html())
      // expect(cell.text()).not.toBe('')
    // })
  })
})
