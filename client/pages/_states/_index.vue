<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid gutter>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <div ref="cases">
              <form>
                <h3 class="typography typography--title m-b-md">Cidade</h3>
                <cov-select v-model="city" :options="dashboard.cities" @input="filterCity" />
              </form>

              <div class="m-t-lg">
                <h3 class="typography typography--title">Casos</h3>
                <div class="typography typography--subtitle m-b-md">{{ updatedDistance('covid_cases') }}</div>

                <cov-grid v-if="dashboard.covid_cases" gutter>
                  <cov-grid-cell v-for="(item, key) in dashboard.covid_cases.cases" :key="key" :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
                    <cov-card>
                      <div>{{ casesTypes[key].label }}</div>
                      <div class="typography--heavy-text" :class="casesTypes[key].classes">{{ item }}</div>
                      <client-only>
                        <cov-bar-chart :chart-data="casesChartData[key]" :options="casesChartOptions" style="height: 150px;" />
                      </client-only>
                    </cov-card>
                  </cov-grid-cell>
                </cov-grid>
              </div>
            </div>
          </cov-grid-cell>

          <cov-grid-cell v-if="fetchSuccess" :breakpoints="{ sm: 'full', lg: '1-of-2' }">
            <cov-heatmap :height="mapHeight" />
          </cov-grid-cell>
        </cov-grid>

        <cov-grid align-bottom justify-between>
          <cov-grid-cell :breakpoints="{ sm: 'full', lg: '4-of-12' }" class="m-t-lg">
            <h3 class="typography typography--title">Leitos</h3>

            <div class="typography typography--subtitle m-b-md">
              <abbr :title="updatedDate('beds')">{{ updatedDistance('beds') }}</abbr>
            </div>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full', lg: 'fill' }" class="m-t-lg m-b-lg">
            <form>
              <cov-grid align-middle align-right>
                <cov-grid-cell :breakpoints="{ col: 'fit' }">
                  <h3 class="typography typography--title m-r-md">Hospitais</h3>
                </cov-grid-cell>

                <cov-grid-cell :breakpoints="{ sm: 'fit', lg: '9-of-12' }">
                  <cov-select v-model="hospital" :options="hospitalOptions" @input="filter" />
                </cov-grid-cell>
              </cov-grid>
            </form>
          </cov-grid-cell>

          <div class="beds">
            <cov-grid gutter>
              <cov-grid-cell v-for="(item, key) in beds" :key="key" :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
                <cov-card class="typography">
                  <template v-slot:header>
                    <span class="beds__title">{{ bedsTypes[key].label }}</span>
                  </template>
                  <div>
                    <cov-grid align-bottom justify-between>
                      <cov-grid-cell :breakpoints="{ col: '1-of-2'}" class="beds__content p-r-md">
                        <div class="beds__box">
                          <div class="typography--caption">
                            COVID-19
                            <div>Ocupação</div>
                          </div>
                          <cov-badge :percent="badgesPercent(item.covid)">{{ badgesPercent(item.covid) }}</cov-badge>
                        </div>
                        <div class="beds__box m-t-md">
                          <span>Total</span>
                          <span class="typography--weight-bold typography--primary-color">{{ totalBeds(item.covid) }}</span>
                        </div>
                        <div class="beds__box">
                          <span>Ocupados</span>
                          <span class="typography--weight-bold typography--primary-color">{{ item.covid.busy }}</span>
                        </div>
                      </cov-grid-cell>

                      <cov-grid-cell :breakpoints="{ col: '1-of-2'}" class="beds__content p-l-md">
                        <div class="typography--caption beds__spacing-top">Não Covid-19</div>
                        <div class="beds__box m-t-md">
                          <span>Total</span>
                          <span class="typography--weight-bold typography--primary-color">{{ totalBeds(item.normal) }}</span>
                        </div>
                        <div class="beds__box">
                          <span>Ocupados</span>
                          <span class="typography--weight-bold typography--primary-color">{{ item.normal.busy }}</span>
                        </div>
                      </cov-grid-cell>
                    </cov-grid>
                  </div>
                </cov-card>
              </cov-grid-cell>
            </cov-grid>
          </div>
        </cov-grid>

        <div class="m-t-md">
          <cov-button href="https://placehold.it/100x100" icon="table_chart" label="Baixar planilha" target="_blank" />
          <cov-button href="https://placehold.it/100x100" icon="code" label="Acesso a API" target="_blank" />
        </div>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid gutter justify-between>
          <cov-grid-cell :breakpoints="{ col: 'full' }">
            <h3 class="typography typography--title">Histórico</h3>

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

import { format, formatDistanceToNow } from 'date-fns'
import { ptBR } from 'date-fns/locale'

import CovBadge from '~/components/CovBadge'
import CovBarChart from '~/components/CovBarChart'
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
    CovBarChart,
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

  validate ({ params }) {
    return params.states === 'sp'
  },

  data () {
    return {
      showLoading: false,
      city: '',
      hospital: '',
      mapHeight: null,
      fetchSuccess: false
    }
  },

  computed: {
    ...mapGetters({
      dashboard: 'dashboard/dashboard',
      error: 'dashboard/error'
    }),

    beds () {
      if (this.dashboard.beds) {
        const { updated_at: updatedAt, ...beds } = this.dashboard.beds
        return beds
      }

      return {}
    },

    bedsTypes () {
      return {
        intensive_care_unit: { label: 'UTI' },
        nursing: { label: 'Enfermaria' },
        ventilator: { label: 'Respiradores' }
      }
    },

    casesChartData () {
      if (!this.historyCases) {
        return null
      }

      const limit = 15

      const datasets = {}
      const labels = this.historyDates.slice(0, limit)
      const total = this.historyCases.total.slice(0, limit)

      for (const key of Object.keys(this.historyCases)) {
        const { label, color } = this.casesTypes[key]
        const data = this.historyCases[key].slice(0, limit)

        datasets[key] = {
          labels,
          datasets: [
            {
              label,
              backgroundColor: color,
              maxBarThickness: 3,
              data
            },
            {
              backgroundColor: '#e5e5e5',
              maxBarThickness: 3,
              data: total.map((day, index) => day - data[index])
            }
          ]
        }
      }

      return datasets
    },

    casesChartOptions () {
      const scale = [{
        ticks: { beginAtZero: true, display: false },
        gridLines: { display: false, drawTicks: false },
        stacked: true
      }]

      return {
        legend: { display: false },
        scales: { yAxes: scale, xAxes: scale }
      }
    },

    casesTypes () {
      return {
        total: {
          label: 'Total',
          classes: 'text-primary',
          color: '#a3a1fb'
        },

        deaths: {
          label: 'Mortes',
          classes: 'text-negative',
          color: '#fA5252'
        },

        cureds: {
          label: 'Recuperados',
          classes: 'text-positive',
          color: '#34c360'
        }
      }
    },

    hasError () {
      return !!this.error
    },

    historyCases () {
      const { historical } = this.dashboard

      const cases = {}

      for (const date of this.historyKeys) {
        const data = historical[date].covid_cases

        for (const key of Object.keys(data)) {
          cases[key] ? cases[key].push(data[key]) : cases[key] = [data[key]]
        }
      }

      return cases
    },

    historyDates () {
      return this.historyKeys.map(
        date => format(new Date(date), 'dd/MM/yyyy')
      )
    },

    historyKeys () {
      const { historical } = this.dashboard
      return historical ? Object.keys(historical) : []
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
          },
          {
            label: 'Segunda linha',
            backgroundColor: '#f87979',
            data: [getRandomInt(), getRandomInt()]
          }
        ]
      }
    },

    hospitalOptions () {
      const { cities } = this.dashboard

      return cities
        ? cities.find(option => option.value === this.city).hospitals
        : []
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

  destroyed () {
    window.removeEventListener('resize', this.setHeight)
  },

  methods: {
    ...mapActions({
      fetchDashboard: 'dashboard/fetch'
    }),

    badgesPercent ({ busy, free }) {
      const total = busy + free
      const percent = (((100 * busy) / total) || 0).toFixed('2')

      return `${percent}%`
    },

    clearHospital () {
      this.hospital = ''
    },

    async fetch () {
      this.showLoading = true

      try {
        await this.fetchDashboard({ ...this.$route.query, city: this.$route.params.index })
        this.setMapHeight()
        this.fetchSuccess = true
      } catch (error) {
        this.fetchSuccess = false
        throw new Error('Error fetching "dashboard" data.', error)
      } finally {
        this.showLoading = false
      }
    },

    filter (isCity) {
      if (isCity && typeof isCity === 'boolean') {
        return this.$router.push({ params: { index: this.city } })
      }

      const query = omitBy({ ...this.$route.query, hospital: this.hospital }, isEmpty)
      this.$router.push({ query })
    },

    filterCity () {
      this.clearHospital()
      this.filter(true)
    },

    formatDateTime (value, token = 'dd/MM/yyyy HH:mm:ss', options) {
      return format(value, token, { locale: ptBR, ...options })
    },

    setSelect () {
      this.city = this.$route.params.index || 'ribeirao-preto'
      this.hospital = this.$route.query.hospital || ''
    },

    totalBeds ({ busy, free }) {
      return busy + free
    },

    updatedDate (model) {
      model = this.dashboard[model]
      return model ? this.formatDateTime(new Date(model.updated_at)) : ''
    },

    updatedDistance (model) {
      model = this.dashboard[model]

      if (model) {
        const distance = formatDistanceToNow(
          new Date(model.updated_at),
          { locale: ptBR }
        )

        return `Atualizado há ${distance}`
      }

      return ''
    },

    setMapHeight (defaultHeight = 300) {
      this.setHeight()

      window.addEventListener('resize', this.setHeight)
    },

    setHeight (defaultHeight) {
      const height = window.screen.width

      this.mapHeight = height < 768 ? `${defaultHeight}px` : `${this.$refs.cases.clientHeight}px`
    }
  }
}
</script>

<style lang="scss">
.beds {
  &__title {
    font-size: 16px;
  }

  &__box {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
  }

  &__content {
    & + & {
      border-left: 1px solid $tertiary-color;
    }
  }
}
</style>
