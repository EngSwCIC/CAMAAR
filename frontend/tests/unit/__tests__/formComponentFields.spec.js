import LoginCard from 'src/components/LoginCard.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest';
installQuasarPlugin();
describe('Login Component', () => {
  it('Mounts without error', () => {
    const wrapper = mount(LoginCard);
    expect(wrapper).toBeTruthy()
  })
})
