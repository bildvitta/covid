<template>
  <transition name="fade">
    <div v-if="show" class="cov-loading">
      <div class="cov-loading__icon">
        loading...
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    show: {
      type: Boolean
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
    animation: spninner 2s linear infinite;
    left: 50%;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
  }
}

// transition
.fade-leave-to,
.fade-enter {
  opacity: 0;
}

.fade-leave-active,
.fade-enter-active {
  transition: opacity 300ms ease-in-out;
}
</style>
