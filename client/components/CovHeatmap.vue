<template>
  <div class="cov-heatmap" :style="{ height }">
    <client-only>
      <l-map :center="[-21.1775, -47.81028]" :options="{ attributionControl: false }" :zoom="12">
        <l-tile-layer url="http://{s}.tile.osm.org/{z}/{x}/{y}.png" />
        <!-- <l-marker :lat-lng="[-21.1775, -47.81028]" /> -->
      </l-map>
    </client-only>
  </div>
</template>

<script>
export default {
  data () {
    return {
      height: '300px'
    }
  },

  computed: {
    heatmapPoints () {
      // https://github.com/Leaflet/Leaflet.heat
      const points = [
        [-21.1775, -47.81028, 0.5]
      ]

      return points
    }
  },

  mounted () {
    this.setMapHeight()
  },

  destroyed () {
    window.removeEventListener('resize', this.setHeight)
  },

  methods: {
    setMapHeight () {
      this.setHeight()

      window.addEventListener('resize', this.setHeight)
    },

    setHeight () {
      const height = window.screen.width
      const parent = this.$el.parentElement

      this.height = height < 768 ? '300px' : `${parent.offsetHeight - 16}px`
    }
  }
}
</script>

<style lang="scss">
.cov-heatmap {
  box-shadow: $shadow;
  width: 100%;
}
</style>
