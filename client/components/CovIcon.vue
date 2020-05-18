<template>
  <i class="cov-icon" :style="styles">{{ name }}</i>
</template>

<script>
export default {
  props: {
    name: {
      required: true,
      type: String
    },

    size: {
      default: '24px',
      type: [String, Number]
    }
  },

  computed: {
    styles () {
      const styles = {
        fontSize: this.sizefy(this.size)
      }

      return styles
    }
  },

  methods: {
    sizefy (value) {
      return value instanceof Number ? `${value}px` : value
    }
  }
}
</script>

<style lang="scss">
.cov-icon {
  display: inline-block;
  font-family: 'Material Icons Outlined', monospace;
  font-feature-settings: 'liga';
  font-size: 24px;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  font-style: normal;
  font-weight: normal;
  letter-spacing: normal;
  line-height: 1;
  text-rendering: optimizeLegibility;
  text-transform: none;
  white-space: nowrap;
  word-wrap: normal;
}
</style>
