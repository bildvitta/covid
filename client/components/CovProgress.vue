<template>
  <div class="cov-progress">
    <div v-for="(item, index) in content" :key="index" class="cov-progress__content" :class="backgroundClass(item)" :style="style(item, index)">
      <span class="cov-progress__text">{{ item.width }}</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: Array,
      required: true,
      default: () => []
    }
  },

  watch: {
    content () {
      this.checkContent()
    }
  },

  created () {
    this.checkContent()
  },

  methods: {
    style ({ width }, index) {
      const isLast = this.content.length - 1 === index

      return { width: `calc(${width}% + ${isLast ? 0 : 4}px)` }
    },

    backgroundClass ({ color }) {
      return color ? `bg-${color}` : 'bg-primary'
    },

    checkContent () {
      if (this.content.reduce((acc, current) => current.width + acc, 0) > 100) {
        throw new Error('Please, the som of numbers must be less than 100')
      }

      return true
    }
  }
}
</script>

<style lang="scss">
.cov-progress {
  border-radius: $circular-radius;
  display: flex;
  height: 10px;
  margin-bottom: 20px;
  width: 100%;

  &__content {
    &:not(:first-child) {
      margin-left: -4px;
    }

    &:not(:last-child) {
      border-radius: $circular-radius 0 0 $circular-radius;
    }

    border-radius: $circular-radius;
    position: relative;
  }

  &__text {
    bottom: -20px;
    left: 50%;
    position: absolute;
    transform: translateX(-50%);
  }
}
</style>
