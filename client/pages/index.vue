<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid>
          <cov-grid-cell>
            <form action="">
              Formulário
              <CovSelect v-model="model" map-options :options="[{ label: 'teste', value: 1 }, { label: 'teste2', value: 2 }]">
                <!-- <template v-slot:option-teste="{ option }">
                  <div>
                    {{ option }} Testando slot
                  </div>
                </template> -->
              </CovSelect>
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
              <cov-button href="#" icon="table_chart" label="Baixar planilha" />
              <cov-button href="#" icon="code" label="Acesso a API" />
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
import CovButton from '~/components/CovButton'
import CovBox from '~/components/CovBox'
import CovCard from '~/components/CovCard'
import CovGrid from '~/components/CovGrid'
import CovGridCell from '~/components/CovGridCell'
import CovHeatmap from '~/components/CovHeatmap'
import CovLineChart from '~/components/CovLineChart'
import CovLoading from '~/components/CovLoading'
import CovSection from '~/components/CovSection'
import CovSelect from '~/components/CovSelect'

export default {
  components: {
    CovBadge,
    CovBox,
    CovButton,
    CovCard,
    CovGrid,
    CovGridCell,
    CovHeatmap,
    CovLineChart,
    CovLoading,
    CovSection,
    CovSelect
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
