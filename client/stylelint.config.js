module.exports = {
  extends: 'stylelint-config-standard',

  plugins: [
    'stylelint-order',
    'stylelint-selector-bem-pattern'
  ],

  rules: {
    'at-rule-no-unknown': null,
    'order/properties-alphabetical-order': true,
    'plugin/selector-bem-pattern': { preset: 'bem' }
  }
}
