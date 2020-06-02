<template>
  <div class="cov-box" :class="borderClass">
    <slot />
  </div>
</template>

<script>
export default {
  props: {
    outlined: {
      type: [Boolean, String],
      default: false
    }
  },

  computed: {
    borderClass () {
      if (this.outlined && typeof this.outlined === 'boolean') {
        return 'cov-box--outlined'
      }

      return this.outlined ? `cov-box--outlined cov-box--${this.outlined}` : ''
    }
  }
}
</script>

<style lang="scss">
.cov-box {
  $root: &;

  border-radius: $radius;
  padding: 15px;
  width: 100%;

  &:not(&--flat) {
    box-shadow: $shadow;
  }

  &:not(&--outlined) {
    background-color: $white;
  }

  &--primary {
    &#{$root}--outlined {
      border-color: $primary-color;
    }
  }

  &--negative {
    &#{$root}--outlined {
      border-color: $negative-color;
    }
  }

  &--positive {
    &#{$root}--outlined {
      border-color: $positive-color;
    }
  }

  &--warning {
    &#{$root}--outlined {
      border-color: $warning-color;
    }
  }

  &--outlined {
    background: transparent;
    border-style: solid;
    border-width: 1px;
  }
}
</style>
