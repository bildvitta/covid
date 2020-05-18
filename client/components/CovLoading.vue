<template>
  <transition :name="transition">
    <div v-if="showing" class="cov-loading">
      <slot>
        <div class="cov-loading__icon">
          loading...
        </div>
      </slot>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    showing: {
      type: Boolean
    },

    transition: {
      default: 'fade',
      type: String
    }
  }
}
</script>

<style lang="scss">
.cov-loading {
  backdrop-filter: blur(5px);
  background-color: rgba($primary-color, 0.5);
  bottom: 0;
  left: 0;
  position: absolute;
  right: 0;
  top: 0;
  z-index: 99999;

  &__icon {
    animation: spninner 2s linear infinite;
    left: 50%;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
  }
}
</style>
