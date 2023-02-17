const { defineConfig } = require("cypress");

module.exports = defineConfig({
  projectId: '194kiz',
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
