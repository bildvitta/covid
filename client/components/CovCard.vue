<template>
  <cov-box>
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

  computed: {
    hasHeader () {
      return !!(this.$slots.header || this.$scopedSlots.header)
    }
  }
}
</script>

<style lang="scss">
  .card {
    &__header {
      align-items: center;
      display: flex;
      font-size: 14px;
      justify-content: space-between;

      & + * {
        margin-top: $space-sm;
      }
    }
  }
</style>
