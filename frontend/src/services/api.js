import axios from "axios";

const api = axios.create({
  baseURL: "http://127.0.0.1:3000",
  // headers: ('Access-Control-Allow-Origin: *'),

  // baseURL: "https://canvasjs.com",
});

export default api;