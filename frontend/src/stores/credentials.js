import { defineStore } from "pinia";
import axios from "axios";

export const credentialsStore = defineStore("credentials", {
  state: () => ({
    user: null,
  }),
  actions: {
    authenticate: async (user) => {
      try {
        // const { data } = await axios.post("/api/auth", user);
        // localStorage.setItem("token", data.token);
        localStorage.setItem("token", "Token temporario");
        console.log('teste')
        return true;
      } catch (error) {
        console.error(error);
        throw new Error("Error ao autenticar usuario", error);
      }
    },
    isAuthenticated: () => {
      console.log(localStorage.getItem("token"));
      const token = localStorage.getItem("token");
      if (token) {
        try {
          // const { data } = axios.post("/api/auth", token);
          const data = { authenticated: true };
          return data.authenticated;
        } catch (err) {
          localStorage.removeItem("token");
          console.error(err);
          return false;
        }
      }
      return false;
    },
  },
});
