export default function ({ $axios }) {
  $axios.defaults.baseURL = process.env.baseUrl
}
