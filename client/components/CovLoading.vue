<template>
  <transition :name="transition">
    <div v-if="showing" class="cov-loading">
      <slot>
        <cov-icon class="cov-loading__icon" name="cached" size="48px" />
      </slot>
    </div>
  </transition>
</template>

<script>
import CovIcon from '~/components/CovIcon'

export default {
  components: {
    CovIcon
  },

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
  background-color: rgba($primary-color, 0.25);
  bottom: 0;
  left: 0;
  position: fixed;
  right: 0;
  top: 0;
  z-index: 1000;

  &__icon {
    animation: spinner 2s linear infinite;
    color: $text-color;
    left: calc(50% - 24px);
    position: absolute;
    top: calc(50% - 24px);
    transform-origin: center;
  }
}
</style>
