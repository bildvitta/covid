<template>
  <div class="badge" :class="classes">
    <slot />
  </div>
</template>

<script>
export default {
  props: {
    color: {
      default: 'primary',
      type: String
    },

    outlined: {
      type: Boolean
    }
  },

  computed: {
    classes () {
      const value = parseFloat(this.$slots.default[0].text)

      if (value < 60) {
        return 'badge--positive'
      }

      return value >= 60 && value < 90 ? 'badge--warning' : 'badge--negative'
    }
  }
}
</script>

<style lang="scss">
.badge {
  background-color: $primary-color;
  border-radius: $radius;
  color: $white;
  display: inline;
  font-size: $font-size-small;
  font-weight: bold;
  padding: 3px 6px;

  &--negative {
    background-color: $negative-color;
  }

  &--positive {
    background-color: $positive-color;
  }

  &--warning {
    background-color: $warning-color;
  }
}
</style>
