<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid>
          <cov-grid-cell>
            <form action="">
              <div>
                <h3 class="typography typography--title">Cidade</h3>
                <cov-select v-model="city" :options="dashboard.cities" @input="filter" />
              </div>

              <div>
                <h3 class="typography typography--title">Hospitais</h3>
                <cov-select v-model="hospital" :options="hospitalOptions" @input="filter" />
              </div>
            </form>

            <div>
              <h3 class="typography typography--title">Leitos</h3>
              <div class="typography typography--subtitle">Atualizado há 10 min</div>

              <cov-grid class="cov-grid--with-gutter">
                <cov-grid-cell :breakpoints="{ col: '1-of-2', sm: '1-of-2', md: '1-of-3', lg: '1-of-3' }">
                  <cov-card class="typography">
                    <template v-slot:header>
                      <span>UTI</span>
                      <cov-badge color="negative">12,5%</cov-badge>
                    </template>

                    <div>
                      <cov-grid class="cov-grid--justify-between">
                        <div class="typography--caption">Covid-19</div>

                        <cov-grid-cell><span>Total</span></cov-grid-cell>

                        <cov-grid-cell :breakpoints="{col: 'Fit', sm: 'Fit', md: 'Fit', lg: 'Fit'}">
                          <span class="typography--weight-bold typography--primary-color">150</span>
                        </cov-grid-cell>

                        <cov-grid-cell><span>Ocupados</span></cov-grid-cell>

                        <cov-grid-cell :breakpoints="{col: 'Fit', sm: 'Fit', md: 'Fit', lg: 'Fit'}">
                          <span class="typography--weight-bold typography--primary-color">150</span>
                        </cov-grid-cell>

                        <div class="typography--caption">Não Covid-19</div>

                        <cov-grid-cell><span>Total</span></cov-grid-cell>

                        <cov-grid-cell :breakpoints="{col: 'Fit', sm: 'Fit', md: 'Fit', lg: 'Fit'}">
                          <span class="typography--weight-bold typography--primary-color">150</span>
                        </cov-grid-cell>

                        <cov-grid-cell><span>Ocupados</span></cov-grid-cell>

                        <cov-grid-cell :breakpoints="{col: 'Fit', sm: 'Fit', md: 'Fit', lg: 'Fit'}">
                          <span class="typography--weight-bold typography--primary-color">150</span>
                        </cov-grid-cell>
                      </cov-grid>
                    </div>
                  </cov-card>
                </cov-grid-cell>
              </cov-grid>

              <cov-badge>100%</cov-badge>
              <cov-badge color="negative">12,5%</cov-badge>
              <cov-badge color="positive">89,14%</cov-badge>
              <cov-badge color="warning">67,5%</cov-badge>
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
      showLoading: false,
      city: 'ribeirao-preto',
      hospital: ''
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
    },

    hospitalOptions () {
      return this.dashboard.cities ? this.dashboard.cities.find(item => item.value === this.city).hospitals : []
    }
  },

  watch: {
    $route () {
      this.fetch()
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
        await this.fetchDashboard(this.$route.query)
      } catch (error) {
        throw new Error('Error fetching "dashboard" data.', error)
      } finally {
        this.showLoading = false
      }
    },

    filter () {
      const query = {
        city: this.city,
        hospital: this.hospital
      }

      this.$router.push({ query })
    }
  }
}
</script>
