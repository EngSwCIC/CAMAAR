import SubjectReportTable from "frontend/src/components/SubjectReportTable.vue"
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
installQuasarPlugin();

describe('SubjectReportTable', () => {
    beforeEach(() => {
        
    })

    it('renders correct values', () => {
        const wrapper = mount(SubjectReportTable, {
            propsData: {
                subject: {
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
            }
        })
        let headerRow = wrapper.findAll('thead > tr')[0]
        let dataRow = wrapper.findAll('tbody > tr')[0]
        
        let data = dataRow.findAll('td').map(item => item.text())
        let headers = headerRow.findAll('th').map(item => item.text())


        expect(data[0]).toBe('5,5')
        expect(data[1]).toBe('8,9')
        expect(headers[0]).toBe('T0arrow_upward')
        expect(headers[1]).toBe('OIarrow_upward')
    })
})
