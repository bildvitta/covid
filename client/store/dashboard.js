const state = () => ({
  dashboard: {},
  fetchSuccess: false,
  isFetching: false,
  params: {},
  error: {}
})

const getters = {
  dashboard: state => state.dashboard,
  error: state => state.error,
  fetchSuccess: state => state.fetchSuccess,
  params: state => state.params,
  isFetching: state => state.isFetching,
  clearHospitalSelect: state => state.clearHospitalSelect
}

const actions = {
  async fetch ({ commit }, params) {
    commit('fetchStart', true)

    try {
      const { data } = await this.$axios.get('dashboard', { params })
      commit('setDashboard', { data, params })
      return data
    } catch (error) {
      commit('setError', error)
      throw new Error('Error fetching "dashboard" data.', error)
    } finally {
      commit('fetchStart', false)
    }
  }
}

const mutations = {
  setDashboard (state, { data, params }) {
    state.dashboard = data
    state.params = { ...params }
    state.fetchSuccess = true
  },

  setError (state, error) {
    state.error = error
    state.fetchSuccess = false
  },

  fetchStart (state, start) {
    state.isFetching = start
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
