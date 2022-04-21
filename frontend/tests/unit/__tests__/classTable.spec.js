import StudentClass from "frontend/src/pages/StudentClass.vue"
import {mount} from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

const rows = [
  {
    student: 'Maria',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Duda',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Cleude',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Jertrudes',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Lubas',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Otavio',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Paulo Otavio',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    student: 'Janaina',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  }
]

const rowsAverage = [
  {
    average: 'Média Unidade',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  },
  {
    average: 'Média Turma',
    question1: 1,
    question2: 2,
    question3: 3,
    question4: 4,
    question5: 5,
    question6: 3,
    question7: 2,
    question8: 4,
    question9: 1,
    question10: 2,
    question11: 5,
    question12: 3,
    question13: 4,
    question14: 1
  }
]

describe('StudentClass', () => {
  let wrapper;
  beforeEach(() => {
    wrapper = mount(StudentClass, {
      propsData: {
        rows,
        rowsAverage
      }
    })
  })

  it('renders-tables-correct-values', () => {
    let $rows = wrapper.findAll('tbody > tr')

    let column1 = $rows.map(row => {
      return row.
      findAll('td')
        .at(0)
        .text()
    })

    expect(column1[0]).toBe('Média Unidade')
    expect(column1[1]).toBe('Média Turma')
    expect(column1[2]).toBe('Maria')
    expect(column1[3]).toBe('Duda')
    expect(column1[4]).toBe('Cleude')
    expect(column1[5]).toBe('Jertrudes')
    expect(column1[6]).toBe('Lubas')
  });

})