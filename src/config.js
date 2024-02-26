export default {
  backendUrl: import.meta.env.MODE === "production" ? "/" : "http://localhost:8080/"
};
