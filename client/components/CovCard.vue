<template>
  <cov-box v-bind="$attrs">
    <div v-if="hasHeader" class="card__header">
      <slot name="header" />
    </div>

    <slot name="content" />

    <slot />
  </cov-box>
</template>

<script>
import CovBox from '~/components/CovBox'

export default {

  components: {
    CovBox
  },

  props: {
    percent: {
      type: Number,
      default: 0
    },

    lighten: {
      type: Boolean
    }
  },

  computed: {
    hasHeader () {
      return !!(this.$slots.header || this.$scopedSlots.header)
    },

    lightenClass () {
      let className = ''

      for (const key in this.percentClasses) {
        if (this.percentClasses[key]) {
          className = key
        }
      }

      return { [`${className}-lighten`]: this.lighten }
    },

    classes () {
      return {
        ...this.lightenClass, ...this.percentClasses
      }
    },

    percentClasses () {
      const percent = parseFloat(this.percent)

      return {
        'card--negative': percent >= 80,
        'card--warning': percent >= 60 && percent < 70,
        'card--positive': percent < 60
      }
    }
  }
}
</script>

<style lang="scss">
  .card {
    &__header {
      align-items: center;
      color: $primary-color;
      display: flex;
      font-size: 14px;
      justify-content: space-between;

      & + * {
        margin-top: $space-xs;
      }
    }

    &--positive {
      background-color: $positive-color;
    }

    &--warning {
      background-color: $warning-color;
    }

    &--negative {
      background-color: $negative-color;
    }

    &--positive-lighten {
      background-color: lighten($positive-color, 40%);
      color: $positive-color;
    }

    &--warning-lighten {
      background-color: lighten($warning-color, 40%);
      color: $warning-color;
    }

    &--negative-lighten {
      background-color: lighten($negative-color, 40%);
      color: $negative-color;
    }
  }
</style>
