import LoginCard from '../../../src/components/LoginCard.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
import { createTestingPinia } from '@pinia/testing'
import { setActivePinia, createPinia } from 'pinia'

installQuasarPlugin();
describe('Login Component', () => {
  beforeEach(() => {
    // creates a fresh pinia and make it active so it's automatically picked
    // up by any useStore() call without having to pass it to it:
    // `useStore(pinia)`
    setActivePinia(createPinia())
  })
  it('Mounts without error', () => {
    const wrapper = mount(LoginCard, {
      global: {
        plugins: [createTestingPinia()],
      },
    })
    expect(wrapper).toBeTruthy()
  })
})
