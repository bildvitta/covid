<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid>
          <cov-grid-cell>
            <form action="">
              Formulário
            </form>

            <div>
              <h3 class="typography typography--title">Leitos</h3>
              <div class="typography typography--subtitle">Atualizado há 10 min</div>

              <CovBadge>100%</CovBadge>
              <CovBadge color="negative">12,5%</CovBadge>
              <CovBadge color="positive">89,14%</CovBadge>
              <CovBadge color="warning">67,5%</CovBadge>
            </div>

            <div>
              <h3 class="typography typography--title">Casos em Ribeirão Preto</h3>
              <div class="typography typography--subtitle">Atualizado há 10 min</div>

              <cov-card>
                Card
              </cov-card>
            </div>

            <div>
              Botões
            </div>
          </cov-grid-cell>
          <cov-grid-cell>
            <cov-heatmap />
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid>
          <cov-grid-cell>
            <h3 class="typography typography--title">Dashboard 1</h3>
            <cov-box>
              <client-only>
                <cov-line-chart :chart-data="historyChartData" />
              </client-only>
            </cov-box>
          </cov-grid-cell>

          <cov-grid-cell>
            <h3 class="typography typography--title">Dashboard 2</h3>
            <cov-box>
              <client-only>
                <cov-line-chart :chart-data="historyChartData" />
              </client-only>
            </cov-box>
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-loading :showing="showLoading" />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

import CovBadge from '~/components/CovBadge'
import CovBox from '~/components/CovBox'
import CovCard from '~/components/CovCard'
import CovGrid from '~/components/CovGrid'
import CovGridCell from '~/components/CovGridCell'
import CovHeatmap from '~/components/CovHeatmap'
import CovLineChart from '~/components/CovLineChart'
import CovSection from '~/components/CovSection'
import CovLoading from '~/components/CovLoading'

export default {
  components: {
    CovBadge,
    CovBox,
    CovCard,
    CovGrid,
    CovGridCell,
    CovHeatmap,
    CovLineChart,
    CovLoading,
    CovSection
  },

  data () {
    return {
      showLoading: false
    }
  },

  computed: {
    ...mapGetters({
      dashboard: 'dashboard/dashboard',
      error: 'dashboard/error'
    }),

    hasError () {
      return !!this.error
    },

    historyChartData () {
      function getRandomInt () {
        return Math.floor(Math.random() * (50 - 5 + 1)) + 5
      }

      return {
        labels: [getRandomInt(), getRandomInt()],
        datasets: [
          {
            label: 'Primeira linha',
            backgroundColor: '#f87979',
            data: [getRandomInt(), getRandomInt()]
          }, {
            label: 'Segunda linha',
            backgroundColor: '#f87979',
            data: [getRandomInt(), getRandomInt()]
          }
        ]
      }
    }
  },

  created () {
    this.fetch()
  },

  methods: {
    ...mapActions({
      fetchDashboard: 'dashboard/fetch'
    }),

    async fetch () {
      this.showLoading = true

      try {
        await this.fetchDashboard({ city: 'ribeirao-preto' })
      } catch (error) {
        throw new Error('Error fetching "dashboard" data.', error)
      } finally {
        this.showLoading = false
      }
    }
  }
}
</script>
