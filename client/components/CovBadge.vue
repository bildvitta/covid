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

      return {
        'badge--negative': value >= 90,
        'badge--warning': value >= 60 && value < 90,
        'badge--positive': value < 50
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
