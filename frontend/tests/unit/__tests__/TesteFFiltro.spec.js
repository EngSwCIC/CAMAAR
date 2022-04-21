import StudentFiltro from 'frontend/src/pages/StudentFiltro.vue'
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

describe('Filtro Component', () => {
  beforeEach(() => {
        jest.resetAllMocks();
  });
  it('Tem campo de filtro, e botão de pesquisa', () => {
    const wrapper = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const pesquisa = wrapper.find('[data-test-pesquisa]')
    const filtro = wrapper.find('[data-test-button-filtro]')
    
    expect(pesquisa.attributes()['aria-label']).toContain('pesquisa')
    expect(button.text()).toContain('filtro')
  })    
  it('Mostrar o resultado da pesquisa com o filtro aplicado', async () => {
    const wrapper = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia({
          stubActions: false
        })],
      },
    })
    wrapper.find('[data-test-pesquisa]')
    // Espera o nextTick para ter o tempo de validar a rule após o evento de change
    await wrapper.vm.$nextTick()
    const button = wrapper.find('[data-test-button-filtro]')
    await button.trigger('click')
    await wrapper.vm.$nextTick()
    expect(mockRouterPush).toHaveBeenCalledTimes(1)
    expect(mockRouterPush).toHaveBeenCalledWith({'path': '/home'})
  })

})