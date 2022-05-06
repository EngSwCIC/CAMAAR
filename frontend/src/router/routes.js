import LoginPage from '../pages/LoginPage.vue'
import HomePage from  '../pages/HomePage.vue'
import CadastrarPage from  '../pages/CadastrarPage.vue'
const routes = [
  {
    path: '/',
    name: 'Login',
    component: LoginPage,
  },
  {
    path: '/home',
    name: 'Home',
    component: HomePage,
  },
  {
    path: '/cadastrar',
    name: 'Cadastrar',
    component: CadastrarPage,
  },
  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes
