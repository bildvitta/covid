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

    dense: {
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
        'badge--positive': percent < 60,
        'badge--outline': this.outlined,
        'badge--dense': this.dense,
        [`badge--${this.color}`]: this.color
      }
    }
  }
}
</script>

<style lang="scss">
.badge {
  $root: &;

  align-items: center;
  background-color: $primary-color;
  border-radius: $radius;
  color: $white;
  display: inline-flex;
  font-size: $font-size-small;
  font-weight: bold;
  padding: 3px 6px;
  white-space: nowrap;

  &--dense {
    padding: 2px 8px;
  }

  &--negative {
    background-color: $negative-color;
  }

  &--positive {
    background-color: $positive-color;

    &#{$root}--outline {
      background-color: transparent;
      color: $positive-color;
    }
  }

  &--quaternary {
    background-color: $quaternary-color;

    &#{$root}--outline {
      background-color: transparent;
      color: $quaternary-color;
    }
  }

  &--warning {
    background-color: $warning-color;
  }

  &--outline {
    border: 1px solid;
  }
}
</style>
