import LoginCard from '../../../src/components/LoginCard.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
import { createTestingPinia } from '@pinia/testing'



installQuasarPlugin();

const mockRouterPush = jest.fn();
jest.mock('vue-router', () => ({
  useRouter: () => {
    return {
      name: 'testeDeMock42',
      push: mockRouterPush,
    }
  },
}));

describe('Login Component', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });
  it('Tem campo de email, de senha e botão de entrar', () => {
    const wrapper = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const button = wrapper.find('[data-test-button-login]')
    const senha = wrapper.find('[data-test-senha]')
    const email = wrapper.find('[data-test-email]')

    expect(senha.attributes()['aria-label']).toContain('Senha')
    expect(email.attributes()['aria-label']).toContain('E-Mail')
    expect(button.text()).toContain('Entrar')
  })
  it('Emite error ao tentar logar sem email', async () => {
    const wrapper = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const button = wrapper.find('[data-test-button-login]')
    await button.trigger('click')
    const alert = wrapper.find('div[role="alert"]')
    expect(alert.text()).toContain('E-Mail Obrigatório')
  })
  it('Emite error ao tentar logar sem senha', async () => {
    const wrapper = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })

    wrapper.find('[data-test-email]').setValue("test@gmail.com")
    // Espera o nextTick para ter o tempo de validar a rule após o evento de change
    await wrapper.vm.$nextTick()
    const button = wrapper.find('[data-test-button-login]')
    await button.trigger('click')
    const alert = wrapper.find('div[role="alert"]')
    expect(alert.text()).toContain('Senha Obrigatória')
  })
  it('Loga ao passar usuário e senha válidos', async () => {
    const wrapper = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia({
          stubActions: false
        })],
      },
    })
    wrapper.find('[data-test-email]').setValue("test@gmail.com")
    wrapper.find('[data-test-senha]').setValue("123")
    // Espera o nextTick para ter o tempo de validar a rule após o evento de change
    await wrapper.vm.$nextTick()
    const button = wrapper.find('[data-test-button-login]')
    await button.trigger('click')
    await wrapper.vm.$nextTick()
    expect(mockRouterPush).toHaveBeenCalledTimes(1)
    expect(mockRouterPush).toHaveBeenCalledWith({'path': '/home'})
  })
})
