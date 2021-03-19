export default function ({ $axios }) {
  $axios.defaults.baseURL = 'https://api.leitoscovid.org/dashboard?city=ribeirao-preto'
}
