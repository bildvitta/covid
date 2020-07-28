<template>
  <cov-card class="cov-info-card" :class="percentClasses">
    <cov-grid gutter>
      <cov-grid-cell :breakpoints="{ col: '1-of-3' }">
        <cov-card class="cov-info-card__percent-card" :class="percentCardClasses">
          <div class="cov-info-card__observation text-size-sm">Ocupação</div>
          <div class="text-size-lg text-bold">{{ formatPercent(percent) }}</div>
        </cov-card>
      </cov-grid-cell>

      <cov-grid-cell :breakpoints="{ col: '2-of-3' }">
        <slot name="content" />
      </cov-grid-cell>
    </cov-grid>
  </cov-card>
</template>

<script>
import CovCard from '~/components/CovCard'
import CovGrid from '~/components/CovGrid'
import CovGridCell from '~/components/CovGridCell'

export default {
  components: {
    CovGrid,
    CovGridCell,
    CovCard
  },

  props: {
    percent: {
      type: Number,
      default: 0
    }
  },

  computed: {
    percentClasses () {
      const percent = parseFloat(this.percent) * 100

      return {
        'cov-info-card--red': percent >= 80,
        'cov-info-card--orange': percent >= 75 && percent < 80,
        'cov-info-card--yellow': percent >= 70 && percent < 75,
        'cov-info-card--green': percent < 70
      }
    },

    percentCardClasses () {
      const percent = parseFloat(this.percent) * 100

      return {
        'cov-info-card__percent-card--red': percent >= 80,
        'cov-info-card__percent-card--orange': percent >= 75 && percent < 80,
        'cov-info-card__percent-card--yellow': percent >= 70 && percent < 75,
        'cov-info-card__percent-card--green': percent < 70
      }
    }
  },

  methods: {
    formatPercent (number) {
      const { format } = new Intl.NumberFormat('pt-BR', {
        style: 'percent',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      })

      return format(number)
    }
  }
}
</script>

<style lang="scss">
  .cov-info-card {
    &--green {
      background-color: lighten($green, 40%);
      color: $green;
    }

    &--yellow {
      background-color: lighten($yellow, 35%);
      color: $yellow;
    }

    &--orange {
      background-color: lighten($orange, 35%);
      color: $orange;
    }

    &--red {
      background-color: lighten($red, 25%);
      color: $red;
    }

    &__percent-card {
      color: $white;
      display: flex;
      flex-direction: column;
      height: 100%;
      justify-content: center;

      &--green {
        background-color: $green;
      }

      &--yellow {
        background-color: $yellow;
      }

      &--orange {
        background-color: $orange;
      }

      &--red {
        background-color: $red;
      }
    }

    &__observation {
      color: rgba($white, 0.5);
    }
  }
</style>
