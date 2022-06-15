<<<<<<< HEAD
import LoginPage from '../pages/LoginPage.vue'
import HomePage from  '../pages/HomePage.vue'
import ImportPage from '../pages/ImportPage.vue'

=======
import LoginPage from "../pages/LoginPage.vue";
import HomePage from "../pages/HomePage.vue";
import SurveyPage from "../pages/SurveyPage.vue";
import SurveysPage from "../pages/SurveysPage.vue";
>>>>>>> 0e649a8c2cf653f5fb45c1d92acebc6de9b33a4b
const routes = [
  {
    path: "/",
    name: "Login",
    component: LoginPage,
  },
  {
    path: "/home",
    name: "Home",
    component: HomePage,
  },
  {
<<<<<<< HEAD
    path: '/import',
    name: 'Import',
    component: ImportPage,
  },

=======
    path: "/surveys",
    name: "Questionários",
    component: SurveysPage,
  },
  {
    path: "/surveys/:id",
    name: "Questionário",
    component: SurveyPage,
  },
>>>>>>> 0e649a8c2cf653f5fb45c1d92acebc6de9b33a4b
  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
