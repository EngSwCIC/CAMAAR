import LoginPage from "../pages/LoginPage.vue";
import ImportPage from "../pages/ImportPage.vue";
import HomePage from "../pages/HomePage.vue";
import SurveyPage from "../pages/SurveyPage.vue";
import SurveysPage from "../pages/SurveysPage.vue";
import SurveyCreatePage from "../pages/SurveyCreatePage.vue";
import CadastrarPage from "../pages/CadastrarPage.vue";
import StudentClass from "../pages/StudentClass.vue";
import StudentEvaluationsReport from "../pages/StudentEvaluationsReport.vue";

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
    path: "/import",
    name: "Import",
    component: ImportPage,
  },
  {
    path: "/surveys",
    name: "Questionários",
    component: SurveysPage,
  },
  {
    path: "/surveys/create",
    name: "Criar Questionários",
    component: CreateSurveyPage,
  },
  {
    path: "/surveys/:id",
    name: "Questionário",
    component: SurveyPage,
  },
  {
    path: "/cadastrar",
    name: "Cadastrar",
    component: CadastrarPage,
  },
  {
    path: "/student-class/:id",
    name: "StudentClass",
    component: StudentClass,
  },
  {
    path: "/student-subjects/",
    name: "List",
    component: StudentEvaluationsReport,
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
