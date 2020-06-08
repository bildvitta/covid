import { Doughnut, mixins } from 'vue-chartjs'

export default {
  extends: Doughnut,

  mixins: [mixins.reactiveProp],

  props: {
    options: {
      default: () => ({}),
      type: Object
    },

    type: {
      default: '',
      type: String
    }
  },

  computed: {
    mergedOptions () {
      return {
        maintainAspectRatio: false,
        responsive: true,
        ...this.options
      }
    }
  },

  mounted () {
    this.renderChart(this.chartData, this.mergedOptions)
  }
}
