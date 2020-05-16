<template>
  <div class="badge" :class="classes">
    <slot />
  </div>
</template>

<script>
export default {
  props: {
    color: {
      type: String,
      default: 'primary'
    },

    outlined: {
      type: Boolean
    }
  },

  computed: {
    classes () {
      return `badge--${this.color}`
    }
  }
}
</script>

<style lang="scss">
  @import '../assets/styles/settings.scss';

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
