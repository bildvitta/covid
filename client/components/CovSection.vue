<template>
  <section class="cov-section" :class="classes">
    <slot />
  </section>
</template>

<script>
export default {
  props: {
    color: {
      default: '',
      type: String
    }
  },

  computed: {
    classes () {
      const classes = []

      if (this.color) {
        classes.push(`cov-section--${this.color}`)
      }

      return classes
    }
  }
}
</script>

<style lang="scss">
.cov-section {
  padding: 60px 0;

  &--melrose {
    background-color: rgba($melrose, 0.2);
  }
}
</style>
