import LoginPage from "../pages/LoginPage.vue";
import ImportPage from "../pages/menuCoordenador/ImportPage.vue";
import HomePageC from "../pages/menuCoordenador/HomePageCoordenador.vue";
import HomePageA from "../pages/menuAluno/HomePageAluno.vue";
import HomePageP from "../pages/menuProfessor/HomePageProfessor.vue";
import SurveyPage from "../pages/SurveyPage.vue";
import SurveysPageP from "../pages/menuProfessor/SurveysPageProfessor.vue";
import SurveysPageA from "../pages/menuAluno/SurveysPageAluno.vue";
import SurveysPageC from "../pages/menuCoordenador/SurveysPageCoordenador.vue";
import CadastrarPage from "../pages/CadastrarPage.vue";
import StudentClass from "../pages/StudentClass.vue";
import StudentEvaluationsReport from "../pages/StudentEvaluationsReport.vue";

const routes = [
  //{
  //  path: "/",
  //  name: "Login",
  //  component: LoginPage,
  //},
  {
    path: "/",
    name: "Home",
    component: HomePageC,
  },
  {
    path: "/aluno",
    name: "Home Aluno",
    component: HomePageA,
  },
  {
    path: "/prof",
    name: "Home Professor",
    component: HomePageP,
  },
  {
    path: "/import",
    name: "Import",
    component: ImportPage,
  },
  {
    path: "/surveys/p",
    name: "Questionários Professor",
    component: SurveysPageP,
  },
  {
    path: "/surveys/a",
    name: "Questionários Aluno",
    component: SurveysPageA,
  },
  {
    path: "/surveys/c",
    name: "Questionários Coordenador",
    component: SurveysPageC,
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
