<template>
  <div class="badge" :class="modifier">
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
    modifier () {
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
    font-weight: bold;
    display: inline;
    padding: 3px 6px;
    font-size: $font-size-small;

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
