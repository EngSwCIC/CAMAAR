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

describe('StudentClass', () => {
  let wrapper;
  beforeEach(() => {
    wrapper = mount(StudentClass, {
      propsData: {
        id: 1,
        rows
      }
    })
  })

  it('renders-table', () => {
    expect(wrapper.classes('q-pa-md')).toBe(true)
  });


  it('renders-table-correct-value', () => {
    let $rows = wrapper.findAll('tbody > tr')

    let column1 = $rows.map(row => {
      return row.
      findAll('td')
        .at(0)
        .text()
    })

    expect(column1[0]).toBe('Maria')
    expect(column1[1]).toBe('Duda')
    expect(column1[2]).toBe('Cleude')
    expect(column1[3]).toBe('Jertrudes')
    expect(column1[4]).toBe('Lubas')
  });

})