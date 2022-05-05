import axios from "axios";

const api = axios.create({
  baseURL: "http://0.0.0.0:3030",
  // headers: ('Access-Control-Allow-Origin: *'),

  // baseURL: "https://canvasjs.com",
});

export default api;