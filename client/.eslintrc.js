module.exports = {
  root: true,

  env: {
    browser: true,
    node: true
  },

  parserOptions: {
    parser: 'babel-eslint',
    sourceType: 'module'
  },

  extends: [
    '@nuxtjs',
    'plugin:nuxt/recommended',
    'plugin:vue/recommended',
    'plugin:cypress/recommended'
  ],

  plugins: [
    'cypress'
  ],

  rules: {
    // Recommended
    'vue/max-attributes-per-line': 'off',
    'vue/no-v-html': 'off',
    'vue/singleline-html-element-content-newline': 'off',

    // Uncategorized
    'vue/array-bracket-spacing': ['error', 'never'],
    'vue/arrow-spacing': ['error', { before: true, after: false }],
    'vue/attributes-order': ['error', { alphabetical: true }],
    'vue/block-spacing': ['error', 'always'],
    'vue/no-reserved-component-names': ['error'],
    'vue/script-indent': ['error'],

    // Cypress
    'cypress/no-assigning-return-values': 'error',
    'cypress/no-unnecessary-waiting': 'off',
    'cypress/assertion-before-screenshot': 'warn',
    'cypress/no-force': 'warn',
    'cypress/no-async-tests': 'error'
  }
}
