import LoginPage from '../pages/LoginPage.vue'
import HomePage from  '../pages/HomePage.vue'
import StudentEvaluationsReport from '../pages/StudentEvaluationsReport.vue'
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
    path: '/student/',
    name: 'List',
    component: StudentEvaluationsReport,
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes