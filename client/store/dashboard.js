const state = () => ({
  dashboard: {},
  fetchSuccess: false,
  isFetching: false,
  error: {}
})

const getters = {
  dashboard: state => state.dashboard,
  error: state => state.error,
  fetchSuccess: state => state.fetchSuccess,
  isFetching: state => state.isFetching
}

const actions = {
  async fetch ({ commit }, params) {
    commit('fetchStart', true)

    try {
      const { data } = await this.$axios.get('dashboard', { params })
      commit('setDashboard', data)
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
  setDashboard (state, dashboard) {
    state.dashboard = dashboard
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
