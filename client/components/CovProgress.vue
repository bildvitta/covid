<template>
  <div class="cov-progress">
    <div v-for="(item, index) in formattedContent" :key="index" class="cov-progress__content" :class="backgroundClass(item)" :style="style(item, index)">
      <span class="cov-progress__text text-bold" :class="textClass(item)" :style="style(item, index)">{{ formatPercent(item.value) }}</span>
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

  computed: {
    formattedContent () {
      let total = 0
      let difference = 0

      this.content.forEach((item) => {
        if (item.isTotal) {
          total = item.value
          return
        }

        difference += item.value
      })

      return this.content.map((item) => {
        item.value = item.isTotal
          ? ((item.value - difference) * 100) / total
          : (item.value * 100) / total

        return item
      })
    }
  },

  methods: {
    style ({ value }, index) {
      const isLast = this.content.length - 1 === index

      return { width: `calc(${value}% + ${isLast ? 0 : 4}px)` }
    },

    backgroundClass ({ color }) {
      return color ? `bg-${color}` : 'bg-primary'
    },

    formatPercent (number) {
      number = (number / 100) || 0

      const { format } = new Intl.NumberFormat('pt-BR', {
        style: 'percent',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      })

      return format(number)
    },

    textClass ({ color }) {
      return color ? `text-${color}` : 'bg-primary'
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
