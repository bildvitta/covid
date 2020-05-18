export const state = () => ({
  dashboard: {},
  error: {}
})

export const getters = {
  dashboard: state => state.dashboard,
  error: state => state.error
}

export const mutations = {
  setDashboard (state, dashboard) {
    state.dashboard = dashboard
  },

  setError (state, error) {
    state.error = error
  }
}

export const actions = {
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
