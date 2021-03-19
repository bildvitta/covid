export default function ({ $axios }) {
  $axios.defaults.baseURL = 'https://api.leitoscovid.org/dashboard?city=ribeirao-preto'
  $axios.defaults.baseURL = 'http://localhost:3000'
}
