export default {
  mode: 'universal',

  head: {
    title: 'COVID-19 | Ocupação de leitos hospitalares',

    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.npm_package_description || '' }
    ],

    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Source+Sans+Pro:ital,wght@0,400;0,700;1,400;1,700&family=Material+Icons+Outlined&display=swap' }
    ]
  },

  loading: { color: '#fff' },

  css: [
    '~/assets/styles/components/_container.scss',
    '~/assets/styles/components/_position.scss',
    '~/assets/styles/components/_typography.scss',
    '~/assets/styles/styles.scss',
    '~/assets/styles/utilities/_keyframes.scss',
    '~/assets/styles/utilities/_spaces.scss',
    '~/assets/styles/utilities/_text.scss'
  ],

  styleResources: {
    scss: [
      'breakpoint-sass',
      '~/assets/styles/settings.scss'
    ]
  },

  plugins: [
    '~/plugins/axios'
  ],

  buildModules: [
    '@nuxtjs/eslint-module',
    '@nuxtjs/stylelint-module'
  ],

  modules: [
    '@nuxtjs/axios',
    '@nuxtjs/dotenv',
    '@nuxtjs/pwa',
    '@nuxtjs/style-resources',
    'nuxt-leaflet'
  ],

  // axios: {
  // },

  build: {
    transpile: [
      'lodash-es'
    ]
    // extend (config, context) {}
  }
}
