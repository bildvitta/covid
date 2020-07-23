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
        <!-- <div class="beds__title">{{ bedsTypes[key].label }} <span class="text-caption">COVIDE-19</span></div>

        <div class="beds__box m-t-md">
          <span class="text-black text-bold">Total</span>
          <span class="text-bold text-primary">{{ item.covid.total }}</span>
        </div>

        <div class="beds__box">
          <span class="text-black text-bold">Ocupados</span>
          <span class="text-bold text-primary">{{ item.covid.busy }}</span>
        </div>

        <div class="beds__box">
          <span class="text-black text-bold">Respiradores em uso</span>
          <span class="text-bold text-primary">{{ item.covid.ventilator }}</span>
        </div> -->
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
        'cov-info-card--negative': percent >= 80,
        'cov-info-card--warning': percent >= 60 && percent < 80,
        'cov-info-card--positive': percent < 60
      }
    },

    percentCardClasses () {
      const percent = parseFloat(this.percent) * 100

      return {
        'cov-info-card__percent-card--negative': percent >= 80,
        'cov-info-card__percent-card--warning': percent >= 60 && percent < 80,
        'cov-info-card__percent-card--positive': percent < 60
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
    &--positive {
      background-color: lighten($positive-color, 40%);
      color: $positive-color;
    }

    &--warning {
      background-color: lighten($warning-color, 35%);
      color: $warning-color;
    }

    &--negative {
      background-color: lighten($negative-color, 25%);
      color: $negative-color;
    }

    &__percent-card {
      color: $white;
      display: flex;
      flex-direction: column;
      height: 100%;
      justify-content: center;

      &--positive {
        background-color: $positive-color;
      }

      &--warning {
        background-color: $warning-color;
      }

      &--negative {
        background-color: $negative-color;
      }
    }

    &__observation {
      color: rgba($white, 0.5);
    }
  }
</style>
