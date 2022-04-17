import { createRouter, createWebHistory } from "vue-router";

import { credentialsStore } from "@/store/credentials";

import Login from "../views/Login.vue";
import Home from "../views/Home.vue";
import Professor from "../views/Professor.vue";

const routes = [
  {
    path: "/login",
    name: "Login",
    component: Login,
  },
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/professor",
    name: "Professor",
    component: Professor,
  },
];

const router = createRouter({
  history: createWebHistory("/"),
  routes,
});

router.beforeEach(async (to) => {
  const credentials = credentialsStore();
  const isAuthenticated = await credentials.isAuthenticated();
  console.log(isAuthenticated);
  if (!isAuthenticated && to.name !== "Login") {
    return { name: "Login" };
  }
});

export default router;
