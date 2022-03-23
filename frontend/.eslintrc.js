module.exports = {
  env: {
    node: true,
    "vue/setup-compiler-macros": true,
  },
  extends: ["eslint:recommended", "plugin:vue/vue3-recommended", "prettier"],
  rules: {
    "vue/require-default-prop": "off",
    "vue/multi-word-component-names": "off",
    // override/add rules settings here, such as:
    // 'vue/no-unused-vars': 'error'
  },
};
