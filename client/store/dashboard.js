const state = () => ({
  dashboard: {},
  error: {}
})

const getters = {
  dashboard: state => state.dashboard,
  error: state => state.error
}

const actions = {
  async fetch ({ commit }, params) {
    try {
      const { data } = await this.$axios.get('dashboard', { params })
      commit('setDashboard', data)
      return data
    } catch (error) {
      commit('setError', error)
    }
  }
}

const mutations = {
  setDashboard (state, dashboard) {
    state.dashboard = dashboard
  },

  setError (state, error) {
    state.error = error
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
