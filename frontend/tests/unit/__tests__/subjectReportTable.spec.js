import SubjectReportTable from "frontend/src/components/SubjectReportTable.vue"
import {mount} from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

const subject = {
    name: 'Engenharia de Software',
    classes: [
        {
            grade: 55,
            name: 'T0'
        },
        {
            grade: 89,
            name: 'oi'
        },
    ]
}

describe('SubjectReportTable', () => {
    let wrapper
    beforeEach(() => {
        wrapper = mount(SubjectReportTable, {
            propsData: {
                subject
            }
        })
    })

    it('renders correct values', () => {
        let $rows = wrapper.findAll('tbody > tr')

        let column = $rows.map(row => {
            return row.findAll('tr').at(0).text()
        })

        expect(column[0]).toBe('T0')
        expect(column[1]).toBe('oi')
    })
})
