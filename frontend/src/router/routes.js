import LoginPage from '../pages/LoginPage.vue'
import HomePage from  '../pages/HomePage.vue'
import ProfessorPage from '../pages/ProfessorPage.vue'

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
    path: '/professor',
    name: 'Professor',
    component: ProfessorPage,
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes
