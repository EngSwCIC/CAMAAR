import ImportCard from '../../../src/components/ImportCard.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

const registeredRows = [
  { nome: 'D', codigo: 'Dickerson', turma: 'Macdonald', semestre: '2020-1', horario: '2T' },
  { nome: 'E', codigo: 'Larsen', turma: 'Shaw', semestre: '2020-1', horario: '2T' },
  { nome: 'G', codigo: 'Geneva', turma: 'Wilson', semestre: '2020-1', horario: '2T' },
  { nome: 'T', codigo: 'Jami', turma: 'Carney', semestre: '2020-1', horario: '2T' }
]
const registeredFields = [
    {name:'nome', align: 'center', label: 'Nome', field: 'nome'},
    {name:'codigo', align: 'center', label: 'Código', field: 'codigo'},
    {name:'turma', align: 'center', label: 'Turma', field: 'turma'},
    {name:'semestre', align: 'center', label: 'Semestre', field: 'semestre'},
    {name:'horario', align: 'center', label: 'Horário', field: 'horario'}
  ]

const $axios = {
  get: (url) => {
    return {data: {rows: registeredRows}}
  }
}

describe('Import Page Tests', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('O card existe', () => {
    const wrapper = mount(ImportCard, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    expect(wrapper).toBeTruthy()
  })

  it('O card possui título', () => {
    const wrapper = mount(ImportCard, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    const header = wrapper.find('h3')
    expect(header.text()).toContain('Importar')
  })

  it('O card possui a tabela de turmas para importar', () => {
    const wrapper = mount(ImportCard, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    const table = wrapper.find('#table .q-table__title')

    expect(table.text()).toContain('Importar Turmas')

    const headers = wrapper.findAll('#table th')
    // Contador começa no 1 por causa da checkbox nos headers
    let contador = 1
    registeredFields.forEach( field => {
      expect(headers[contador].text()).toContain(field.label)
      contador++
    })
  })
  it('O card possui o botão de busca de turmas', ()=> {
    const wrapper = mount(ImportCard, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    const button = wrapper.find('#searchButton')
    expect(button.exists()).toBe(true)
  })

  it('Busca turmas ao clicar no botão de "Buscar Turmas"', async ()=> {
    const wrapper = mount(ImportCard, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    await wrapper.find('#searchButton').trigger('click')
    await wrapper.vm.$nextTick()
    const cells = wrapper.findAll('#table td')
    let contador = 0
    let contadorCells = 0
    cells.forEach( cell => {
      // logica de percorrer as rows para validar
      let valores = Object.values(registeredRows[contador])
      if(contadorCells==valores.length){
        contador++
        contadorCells = 0
        valores = Object.values(registeredRows[contador])
      }
      expect(cell).not.toBeNull()
      // ignora de for uma checkbox
      if(cell.classes().includes('q-table--col-auto-width')){
        return
      }
      contadorCells++
      expect(valores.includes(cell.text())).toBe(true)
    })
  })

})

