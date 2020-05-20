<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid gutter>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <form>
              <h3 class="typography typography--title" download>Cidade</h3>
              <cov-select v-model="city" :options="dashboard.cities" @input="filterCity" />
            </form>

            <div>
              <h3 class="typography typography--title">Casos</h3>
              <div class="typography typography--subtitle">{{ updatedAt('covid_cases') }}</div>
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
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <cov-heatmap />
          </cov-grid-cell>
        </cov-grid>

        <cov-grid align-bottom justify-between>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '4-of-12' }">
            <h3 class="typography typography--title">Leitos</h3>
            <div class="typography typography--subtitle">{{ updatedAt('beds') }}</div>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '7-of-12' }">
            <form>
              <h3 class="typography typography--title">Hospitais</h3>
              <cov-select v-model="hospital" :options="hospitalOptions" @input="filter" />
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
                    <cov-grid justify-between>
                      <div class="beds__box">
                        <div class="typography--caption">Covid-19</div>
                        <cov-badge>{{ badgesPercent(item.covid) }}</cov-badge>
                      </div>
                      <div class="beds__box">
                        <span>Total</span>
                        <span class="typography--weight-bold typography--primary-color">{{ totalBeds(item.covid) }}</span>
                      </div>
                      <div class="beds__box">
                        <span>Ocupados</span>
                        <span class="typography--weight-bold typography--primary-color">{{ item.covid.busy }}</span>
                      </div>

                      <div class="typography--caption beds__spacing-top">Não Covid-19</div>

                      <div class="beds__box">
                        <span>Total</span>
                        <span class="typography--weight-bold typography--primary-color">{{ totalBeds(item.normal) }}</span>
                      </div>
                      <div class="beds__box">
                        <span>Ocupados</span>
                        <span class="typography--weight-bold typography--primary-color">{{ item.normal.busy }}</span>
                      </div>
                    </cov-grid>
                  </div>
                </cov-card>
              </cov-grid-cell>
            </cov-grid>
          </div>
        </cov-grid>

        <div>
          <cov-button href="https://placehold.it/100x100" icon="table_chart" label="Baixar planilha" target="_blank" />
          <cov-button href="https://placehold.it/100x100" icon="code" label="Acesso a API" target="_blank" />
        </div>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid gutter justify-between>
          <cov-grid-cell :breakpoints="{ sm: 'full' }">
            <h3 class="typography typography--title">Dashboard 1</h3>

            <cov-box>
              <client-only>
                <cov-line-chart :chart-data="historyChartData" />
              </client-only>
            </cov-box>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <h3 class="typography typography--title">Casos ativos</h3>

            <cov-box>
              <client-only>
                <cov-line-chart :chart-data="historyChartData" />
              </client-only>
            </cov-box>
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <pre>
      {{ dashboard }}
    </pre>

    <cov-loading :showing="showLoading" />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { isEmpty, omitBy } from 'lodash-es'
import { differenceInMinutes, format, parseISO } from 'date-fns'

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
        nursing: { label: 'Enfermagem' },
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

  methods: {
    ...mapActions({
      fetchDashboard: 'dashboard/fetch'
    }),

    differenceInMinutes,

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
    },

    totalBeds ({ busy, free }) {
      return busy + free
    },

    badgesPercent ({ busy, free }) {
      const total = busy + free
      const percent = ((100 * busy) / total).toFixed('2')

      return `${percent}%`
    },

    updatedAt (model) {
      if (!this.dashboard[model]) {
        return ''
      }

      const time = differenceInMinutes(new Date(), parseISO(this.dashboard[model].updated_at))
      return time > 0 ? `Atualizado há ${time} min` : 'Atualizado há menos de 1 min'
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

  &__spacing-top {
    margin-top: 10px;
  }
}
</style>
