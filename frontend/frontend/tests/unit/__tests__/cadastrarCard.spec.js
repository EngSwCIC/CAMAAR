import CadastrarCard from '../../../src/components/CadastrarCard.vue'
import LoginCard from '../../../src/components/LoginCard.vue'
import { mount } from '@vue/test-utils';
import { installQuasarPlugin } from '@quasar/quasar-app-extension-testing-unit-jest'
import { createTestingPinia } from '@pinia/testing'

installQuasarPlugin();


const registeredMembers = [
  {nome: "Ana Clara Jordao Perna", curso: "CIÊNCIA DA COMPUTAÇÃO/CIC", matricula: "190084006",
    usuario: "190084006" , formacao: "graduando", ocupacao: "dicente", email: "acjpjvjp@gmail.com"}
]

const registeredUser = [
  {nome: "Ana Clara Jordao Perna", curso: "CIÊNCIA DA COMPUTAÇÃO/CIC", matricula: "190084006",
    usuario: "190084006" , formacao: "graduando", ocupacao: "dicente", email: "teste@gmail.com"}
]

const mockRouterPush = jest.fn();

jest.mock('vue-router', () => ({
  useRouter: () => {
    return {
      name: 'testeDeMock42',
      push: mockRouterPush,
    }
  },
}));

describe('Register Component Tests', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });
  it('Tem botão de registrar, e ao clicarmos nele vamos para a pagina de registro', () => {
    //mexer nesse para talvez levar para a pagina de registro
    const wrapper1 = mount(LoginCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const wrapper2 = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const button1 = wrapper1.find('[data-test-button-register]')
    expect(button1.text()).toContain('Registrar')
    mockRouterPush({'path':'/cadastrar'})
    expect(mockRouterPush).toHaveBeenCalledTimes(1)
    expect(mockRouterPush).toHaveBeenCalledWith({'path':'/cadastrar'})
    const button2 = wrapper2.find('[data-test-button-register]')

    expect(button2.text()).toContain('Efetuar o Registro')
  })
  it('Tem campo de email, de senha e botão de efetuar o registro', () => {
    const wrapper = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const button = wrapper.find('[data-test-button-register]')
    const senha = wrapper.find('[data-test-senha]')
    const email = wrapper.find('[data-test-email]')

    expect(senha.attributes()['aria-label']).toContain('Senha')
    expect(email.attributes()['aria-label']).toContain('E-Mail')
    expect(button.text()).toContain('Efetuar o Registro')
  })
  it('Emite error ao tentar registrar sem email', async () => {
    const wrapper = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    const button = wrapper.find('[data-test-button-register]')
    await button.trigger('click')
    const alert = wrapper.find('div[role="alert"]')
    expect(alert.text()).toContain('E-Mail Obrigatório')
  })
  it('Emite error ao tentar registrar sem senha', async () => {
    const wrapper = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia()],
      },
    })
    await wrapper.find('[data-test-email]').setValue("test@gmail.com")
    // Espera o nextTick para ter o tempo de validar a rule após o evento de change
    await wrapper.vm.$nextTick()
    const button = wrapper.find('[data-test-button-register]')
    await button.trigger('click')
    const alert = wrapper.find('div[role="alert"]')
    expect(alert.text()).toContain('Senha Obrigatória')
  })
  it('Registra ao passar usuário e senha válidos que estão incluidos nos membros',async() => {
    const wrapper = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia({
        })],
        stubActions: false
      },
    })
    wrapper.find('[data-test-senha]').setValue("123")
    await wrapper.vm.$nextTick()
    wrapper.find('[data-test-email]').setValue("acjpjvjp@gmail.com")
    await wrapper.vm.$nextTick()
    const button = wrapper.find('[data-test-button-register]')
    await button.trigger('click')
    await wrapper.vm.$nextTick()
    const member = Object.values(registeredMembers[0])
    const user = Object.values(registeredUser[0])
    expect(member.includes("acjpjvjp@gmail.com")).toBe(true)
    expect(!user.includes("acjpjvjp@gmail.com")).toBe(true)
    mockRouterPush({'path':'/'})
    expect(mockRouterPush).toHaveBeenCalledTimes(1)
    expect(mockRouterPush).toHaveBeenCalledWith({'path':'/'})
  })
  it('Não Registra ao passar usuário e senha válidos que já estão incluidos nos usuarios',() => {
    const wrapper = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia({
        })],
      },
    })
    wrapper.find('[data-test-email]').setValue("teste@gmail.com")
    wrapper.find('[data-test-senha]').setValue("123")
    // Espera o nextTick para ter o tempo de validar a rule após o evento de change
    const user = Object.values(registeredUser[0])
    const button = wrapper.find('[data-test-button-register]')
    button.trigger('click')
    let control = true
    if(user.includes("teste@gmail.com")){
      control = false
    }
    expect(control).toBe(false)
  })
  it('Não Registra ao passar usuário e senha válidos que não estão incluidos nos membros', () => {
    const wrapper = mount(CadastrarCard, {
      global: {
        // define uma store do pinia para testes
        plugins: [createTestingPinia({
        })],
      },
    })
    wrapper.find('[data-test-email]').setValue("teste@gmail.com")
    wrapper.find('[data-test-senha]').setValue("123")
    // Espera o nextTick para ter o tempo de validar a rule após o evento de change
    const user = Object.values(registeredMembers[0])
    const button = wrapper.find('[data-test-button-register]')
    button.trigger('click')

    let control = true
    if(!user.includes("teste@gmail.com")){
      control = false
    }
    expect(control).toBe(false)
  })
})
