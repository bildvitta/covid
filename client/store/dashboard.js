// import axios from 'axios'

export const state = () => ({
  dashboard: {}
})

export const getters = {
  dashboard: state => state.dashboard
}

export const mutations = {
  setDashboard (state) {
    state.dashboard = 'eh msm'
  }
}

export const actions = {
  async fetch ({ commit }, params) {
    
  }
}
