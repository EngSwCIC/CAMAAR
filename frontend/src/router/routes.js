import LoginPage from '../pages/LoginPage.vue'
import HomePage from  '../pages/HomePage.vue'
import StudentClass from  '../pages/StudentClass.vue'
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
    path: '/student/:id',
    name: 'StudentClass',
    component: StudentClass,
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes
