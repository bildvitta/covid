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
    border-radius: 11px;
    display: inline;
    padding: 3px 6px;

    &--secondary {
      background-color: $secondary-color;
    }
  }
</style>
