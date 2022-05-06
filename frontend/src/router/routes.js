import LoginPage from "../pages/LoginPage.vue";
import HomePage from "../pages/HomePage.vue";
import SurveyPage from "../pages/SurveyPage.vue";
import SurveysPage from "../pages/SurveysPage.vue";
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
    path: "/surveys",
    name: "Questionários",
    component: SurveysPage,
  },
  {
    path: "/surveys/:id",
    name: "Questionário",
    component: SurveyPage,
  },
  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
