<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid gutter justifyBetween>
          <cov-grid-cell :breakpoints="{ col: 'full', sm: 'full', md: 'full', lg: '6-of-12' }">
            <form action="">
              <div>
                <h3 class="typography typography--title">Cidade</h3>
                <cov-select v-model="city" :options="dashboard.cities" @input="filterCity" />
              </div>

              <div>
                <h3 class="typography typography--title">Hospitais</h3>
                <cov-select v-model="hospital" :options="hospitalOptions" @input="filter" />
              </div>
            </form>

            <div>
              <h3 class="typography typography--title">Leitos</h3>
              <div class="typography typography--subtitle">Atualizado há 10 min</div>

              <cov-grid gutter>
                <cov-grid-cell :breakpoints="{ col: 'full', sm: 'full', md: '1-of-3', lg: '1-of-3' }">
                  <cov-card class="typography">
                    <template v-slot:header>
                      <span>UTI</span>
                      <cov-badge color="negative">12,5%</cov-badge>
                    </template>
                    <div>
                      <cov-grid gutter>
                        <div>
                          <div class="typography--caption">Covid-19</div>
                          <cov-grid justifyBetween>
                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span>Total</span>
                            </cov-grid-cell>

                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span class="typography--weight-bold typography--primary-color">150</span>
                            </cov-grid-cell>
                          </cov-grid>

                          <cov-grid justifyBetween>
                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span>Ocupados</span>
                            </cov-grid-cell>

                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span class="typography--weight-bold typography--primary-color">150</span>
                            </cov-grid-cell>
                          </cov-grid>
                        </div>

                        <div>
                          <div class="typography--caption">Não Covid-19</div>
                          <cov-grid justifyBetween>
                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span>Total</span>
                            </cov-grid-cell>

                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span class="typography--weight-bold typography--primary-color">150</span>
                            </cov-grid-cell>
                          </cov-grid>

                          <cov-grid justifyBetween>
                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span>Ocupados</span>
                            </cov-grid-cell>

                            <cov-grid-cell :breakpoints="{col: 'fit', sm: 'fit', md: 'fit', lg: 'fit'}">
                              <span class="typography--weight-bold typography--primary-color">150</span>
                            </cov-grid-cell>
                          </cov-grid>
                        </div>
                      </cov-grid>
                    </div>
                  </cov-card>
                </cov-grid-cell>
              </cov-grid>
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

          <cov-grid-cell :breakpoints="{ col: '1-of-2', sm: '2-of-5', md: '1-of-2', lg: '6-of-12' }">
            <cov-heatmap />
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid gutter justifyBetween>
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
import { isEmpty, omitBy } from 'lodash-es'

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
      city: '',
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
    this.setSelect()
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

    filterCity () {
      this.clearHospital()

      this.filter()
    },

    filter () {
      const query = omitBy({ ...this.$route.query, city: this.city, hospital: this.hospital }, isEmpty)

      this.$router.push({ query })
    },

    setSelect () {
      this.city = this.$route.query.city || 'ribeirao-preto'
      this.hospital = this.$route.query.hospital || ''
    },

    clearHospital () {
      this.hospital = ''
    }
  }
}
</script>
