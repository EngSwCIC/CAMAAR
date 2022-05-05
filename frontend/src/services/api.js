import axios from "axios";

const api = axios.create({
  baseURL: "https://127.0.0.1:3000",
  // headers: ('Access-Control-Allow-Origin: *'),

  // baseURL: "https://canvasjs.com",
});

export default api;