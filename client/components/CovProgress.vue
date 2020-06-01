<template>
  <div class="cov-progress">
    <div class="cov-progress__progress">
      <div v-for="(item, index) in formattedContent" :key="index" class="cov-progress__item" :class="backgroundClass(item)" :style="style(item, index)" />
    </div>
    <div class="cov-progress__content m-t-sm">
      <div v-for="(item, index) in formattedContent" :key="`${index}-span`" class="cov-progress__text text-bold" :class="textClass(item)">
        <span class="cov-progress__ball m-r-sm" :class="backgroundClass(item)" />
        <span class="cov-progress__percent m-r-sm">{{ formatPercent(item.value) }}</span>
        <span class="cov-progress__percent-name text-color text-weght-normal">{{ item.label }}</span>
      </div>
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
      if (!value) {
        return { display: 'none' }
      }

      const isLast = this.content.length - 1 === index
      const width = isLast ? `${value}%` : `calc(${value}% + 4px)`

      return { width }
    },

    backgroundClass ({ color }) {
      return color ? `bg-${color}` : 'bg-primary'
    },

    formatPercent (number) {
      number = (number / 100) || 0

      if (!number) {
        return '---'
      }

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
  margin-bottom: 20px;
  width: 100%;

  &__progress {
    display: flex;
    flex-wrap: wrap;
  }

  &__item {
    &:not(:first-child) {
      margin-left: -4px;
    }

    &:not(:last-child) {
      border-radius: $circular-radius 0 0 $circular-radius;
    }

    border-radius: $circular-radius;
    height: 10px;
    position: relative;
  }

  &__content {
    width: 100%;
  }

  &__ball {
    border-radius: $circular-radius;
    display: block;
    height: 10px;
    width: 10px;
  }

  &__percent {
    width: 61px;
  }

  &__percent-name {
    font-size: 14px;
  }

  &__text {
    align-items: center;
    display: flex;
  }
}
</style>
