<template>
  <div v-if="show" class="cov-loading">
    <div class="cov-loading__icon">
      loading...
    </div>
  </div>
</template>

<script>
export default {
  props: {
    show: {
      type: Boolean
    },

    hide: {
      type: Boolean,
      default: true
    }
  }
}
</script>

<style lang="scss">
  .cov-loading {
    background-color: rgba($primary-color, 0.5);
    bottom: 0;
    left: 0;
    position: fixed;
    right: 0;
    top: 0;
    z-index: 9999;

    &__icon {
      left: 50%;
      position: absolute;
      top: 50%;
      transform: translate(-50%, -50%);
    }
  }
</style>
