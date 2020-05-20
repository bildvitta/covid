import { Bar, mixins } from 'vue-chartjs'

export default {
  extends: Bar,

  mixins: [mixins.reactiveProp],

  props: {
    options: {
      default: () => ({}),
      type: Object
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
