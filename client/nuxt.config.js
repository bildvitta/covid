export default {
  mode: 'universal',

  head: {
    title: 'COVID-19 | Ocupação de leitos hospitalares',

    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.npm_package_description || '' },
      { name: 'theme-color', content: 'white' },
      { hid: 'og:title', content: 'Leitos COVID-19, Ribeirão Preto' },
      { hid: 'og:type', content: 'website' },
      { hid: 'og:url', content: 'https://leitoscovid.org/' },
      { hid: 'og:site_name', content: 'Leitos COVID-19' },
      { hid: 'og:description', content: process.env.npm_package_description || '' },
      { hid: 'og:image', content: 'https://leitoscovid.org/og-image.png' },
      { name: 'twitter:card', content: 'summary_large_image' },
      { name: 'twitter:title', content: 'COVID-19 | Ocupação de leitos hospitalares | Ribeirão Preto' },
      { name: 'twitter:image', content: 'https://leitoscovid.org/og-image.png' },
      { name: 'twitter:description', content: process.env.npm_package_description },
      { name: 'apple-mobile-web-app-title', content: 'Leitos COVID' },
      { name: 'apple-mobile-web-app-status-bar-style', content: 'white' }
    ],

    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'apple-touch-icon', type: 'image/png', href: '/apple-touch-icon.png' },
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Source+Sans+Pro:ital,wght@0,400;0,700;1,400;1,700&family=Material+Icons+Outlined&display=swap' }
    ]
  },

  router: {
    middleware: ['redirect']
  },

  env: {
    baseUrl: process.env.BASE_URL || 'http://localhost:3000'
  },

  loading: { color: '#fff' },

  css: [
    '~/assets/styles/components/_container.scss',
    '~/assets/styles/components/_position.scss',
    '~/assets/styles/styles.scss',
    '~/assets/styles/utilities/_keyframes.scss',
    '~/assets/styles/utilities/_spaces.scss',
    '~/assets/styles/utilities/_text.scss',
    '~/assets/styles/utilities/_background.scss',
    '~/assets/styles/utilities/_border.scss',
    '~/assets/styles/utilities/_flex.scss'
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
    '@nuxtjs/stylelint-module',
    ['@nuxtjs/google-analytics', {
      id: 'UA-168800565-1'
    }]
  ],

  modules: [
    '@nuxtjs/axios',
    '@nuxtjs/dotenv',
    '@nuxtjs/pwa',
    '@nuxtjs/style-resources',
    'nuxt-leaflet'
  ],

  build: {
    babel: {
      plugins: [
        '@babel/plugin-proposal-optional-chaining'
      ]
    },

    transpile: [
      'lodash-es'
    ]
  }
}
