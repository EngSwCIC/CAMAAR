import { defineStore } from "pinia";
import axios from "axios";

export const credentialsStore = defineStore("credentials", {
  state: () => ({
    user: null,
  }),
  actions: {
    authenticate: async (user) => {
      try {
        const { data, headers } = await axios.post("/api/auth/sign_in", {"user": {
          "email": user.email,
          "password": user.password
        }}, {
          validateStatus: function(status) {
            return status >= 200 && status < 300 || status === 401
          }
        });
        if (data.authenticated) {
          localStorage.setItem("token", headers.authorization.split(" ")[1]);
        } 

        return data
      } catch (error) {
        console.error(error);
        throw new Error("Error ao autenticar usuario", error);
      }
    },
    isAuthenticated: () => {
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
