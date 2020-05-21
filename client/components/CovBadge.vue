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
    },

    percent: {
      type: [String, Number],
      default: ''
    }
  },

  computed: {
    classes () {
      const percent = parseFloat(this.percent)

      return {
        'badge--negative': percent >= 90,
        'badge--warning': percent >= 60 && percent < 90,
        'badge--positive': percent < 60
      }
    }
  }
}
</script>

<style lang="scss">
.badge {
  align-items: center;
  background-color: $primary-color;
  border-radius: $radius;
  color: $white;
  display: flex;
  font-size: $font-size-medium;
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
