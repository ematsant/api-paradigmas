/*
 * FEATURE FLAG
 *
 * false: usa o localStorage e funciona abrindo o index.html diretamente.
 * true:  usa a API configurada em API_URL (Elixir na porta 5000).
 */
window.APP_CONFIG = {
  USE_API: true,
  API_URL: "http://localhost:5000",
  LOCAL_STORAGE_KEY: "paradigm-todo.items",
};
