import { Line, mixins } from 'vue-chartjs'

export default {
  extends: Line,

  mixins: [mixins.reactiveProp],

  props: {
    options: {
      default: () => ({}),
      type: Object
    }
  },

  computed: {
    mergedOptions () {
      const defaults = {
        maintainAspectRatio: false,
        responsive: true
      }

      return { ...defaults, ...this.options }
    }
  },

  mounted () {
    this.renderChart(this.chartData, this.mergedOptions)
  }
}
