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

const $axios = {
  get: (url) => {
    return {data: {rows: registeredRows}}
  }
}

describe('Import Page Tests', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('A página existe', () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    expect(wrapper).toBeTruthy()
  })

  it('A página possui título', () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    const header = wrapper.find('h1')
    expect(header.text()).toContain('Import Page')
  })

  it('A página possui a tabela de turmas registradas', () => {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    const table = wrapper.find('#cadastrados .q-table__title')

    expect(table.text()).toContain('Turmas Registradas')

    const headers = wrapper.findAll('#cadastrados th')
    let contador = 0
    registeredFields.forEach( field => {
      expect(headers[contador].text()).toContain(field.label)
      contador++
    })
  })
  it('A pagina possui o botão de busca de turmas', ()=> {
    const wrapper = mount(ImportPage, {
      global: {
        mocks: {
          $axios
        }
      }
    })
    const button = wrapper.find('#searchButton')
    expect(button.exists()).toBe(true)
  })

})

