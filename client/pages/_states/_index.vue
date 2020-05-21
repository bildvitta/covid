<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid v-if="fetchSuccess" gutter>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <div ref="cases">
              <form>
                <h3 class="typography typography--title m-b-md">Cidade</h3>
                <cov-select v-model="city" :options="dashboard.cities" @input="filterCity" />
              </form>

              <div class="m-t-lg">
                <h3 class="typography typography--title">Casos</h3>
                <div class="typography typography--subtitle m-b-md">
                  <abbr :title="updatedDate('covid_cases')">{{ updatedDistance('covid_cases') }}</abbr>
                </div>

                <cov-grid v-if="dashboard.covid_cases" align-center gutter>
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

          <cov-grid-cell :breakpoints="{ sm: 'full', lg: '1-of-2' }">
            <cov-heatmap :points="hospitalsHeatmap" />
          </cov-grid-cell>
        </cov-grid>

        <div class="m-t-md">
          <cov-grid align-bottom class="reverse-row-lg" justify-between>
            <cov-grid-cell :breakpoints="{ sm: 'full', lg: '9-of-12' }">
              <form>
                <cov-grid align-middle class="hospitals-header">
                  <cov-grid-cell :breakpoints="{ col: 'fit' }" class="hospitals-header__title">
                    <h3 class="typography typography--title m-r-md">Hospitais</h3>
                  </cov-grid-cell>

                  <cov-grid-cell :breakpoints="{ sm: 'fit', lg: 'full' }" class="hospitals-header__select m-t-sm">
                    <cov-select v-model="hospital" :options="hospitalOptions" @input="filter" />
                  </cov-grid-cell>
                </cov-grid>
              </form>
            </cov-grid-cell>

            <cov-grid-cell :breakpoints="{ sm: 'full', lg: '3-of-12' }" class="m-t-md">
              <h3 class="typography typography--title">Leitos</h3>

              <div class="typography typography--subtitle">
                <abbr :title="updatedDate('beds')">{{ updatedDistance('beds') }}</abbr>
              </div>
            </cov-grid-cell>
          </cov-grid>
        </div>

        <div class="beds m-t-md">
          <cov-grid align-center gutter>
            <cov-grid-cell v-for="(item, key) in beds" :key="key" :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
              <cov-card class="typography">
                <template v-slot:header>
                  <span class="beds__title">{{ bedsTypes[key].label }}</span>
                </template>
                <div>
                  <cov-grid align-bottom gutter justify-between>
                    <cov-grid-cell :breakpoints="{ col: 'full', sm: 'full', md: '1-of-2', lg: '1-of-2' }" class="beds__content">
                      <div class="beds__box">
                        <div class="typography--caption">
                          COVID-19
                          <div>Ocupação</div>
                        </div>
                        <cov-badge :percent="badgesPercent(item.covid)">{{ badgesPercent(item.covid) }}</cov-badge>
                      </div>
                      <div class="beds__box m-t-md">
                        <span>Total</span>
                        <span class="typography--weight-bold typography--primary-color">{{ item.covid.total }}</span>
                      </div>
                      <div class="beds__box">
                        <span>Ocupados</span>
                        <span class="typography--weight-bold typography--primary-color">{{ item.covid.busy }}</span>
                      </div>
                    </cov-grid-cell>

                    <cov-grid-cell :breakpoints="{ col: 'full', sm: 'full', md: '1-of-2', lg: '1-of-2' }" class="beds__content">
                      <div class="typography--caption beds__spacing-top">Não COVID-19</div>
                      <div class="beds__box m-t-md">
                        <span>Total</span>
                        <span class="typography--weight-bold typography--primary-color">{{ item.normal.total }}</span>
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

        <div class="m-t-xl">
          <!-- <cov-button href="https://placehold.it/100x100" icon="table_chart" label="Baixar planilha" target="_blank" /> -->
          <cov-button href="https://placehold.it/100x100" icon="code" label="Acesso a API" target="_blank" />
        </div>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid gutter justify-between>
          <cov-grid-cell :breakpoints="{ col: 'full', sm: 'full', md: 'full' }">
            <h3 class="typography typography--title">Histórico</h3>

            <cov-box class="m-t-md">
              <client-only>
                <cov-line-chart :chart-data="historyChartData" :options="historyChartOptions" />
              </client-only>
            </cov-box>
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-loading :showing="isFetching" />
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import { isEmpty, isObject, mergeWith, omitBy } from 'lodash-es'

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
      city: '',
      hospital: ''
    }
  },

  computed: {
    ...mapGetters({
      dashboard: 'dashboard/dashboard',
      error: 'dashboard/error',
      fetchSuccess: 'dashboard/fetchSuccess',
      isFetching: 'dashboard/isFetching'
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
          label: 'Confirmados',
          classes: 'text-primary',
          color: '#a3a1fb'
        },

        deaths: {
          label: 'Óbitos',
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

    historyBeds () {
      const { historical } = this.dashboard

      // Lista dos tipos que serão indexados.
      const types = ['intensive_care_unit', 'nursing']

      // Inicia o objeto que conterá os dados resultados.
      const data = {}

      // Laço de datas.
      for (const date of this.historyKeys) {
        const hospitals = historical[date].beds

        // Laço de hospitais.
        for (const hospital of hospitals) {
          const hospitalData = {}

          // Filtra os dados do hospital para os tipos definidos.
          for (const type of types) {
            hospitalData[type] = hospital[type]
          }

          // União e soma dos valores de forma recursiva.
          data[date] = mergeWith(
            {},
            data[date] || {},
            hospitalData,
            (first, second) => {
              if (!isObject(second)) { return (first || 0) + (second || 0) }
            }
          )
        }
      }

      // Concatenação de todos os objetos, transformando o último nó em matriz.
      return mergeWith(
        {},
        ...Object.values(data),
        (first, second) => {
          if (!isObject(second)) { return [...(first || []), second] }
        }
      )
    },

    historyCases () {
      const { historical } = this.dashboard
      const types = {}

      for (const date of this.historyKeys) {
        const data = historical[date].covid_cases

        // Une vários objetos em um único, agrupando em matrizes.
        for (const key of Object.keys(data)) {
          types[key] ? types[key].push(data[key]) : types[key] = [data[key]]
        }
      }

      return types
    },

    historyChartData () {
      return {
        labels: this.historyDates,

        datasets: [
          {
            label: 'Casos confirmados (na cidade)',
            fill: false,
            borderColor: '#e7e7fe',
            data: this.historyCases.total
          },
          {
            label: 'Óbitos (na cidade)',
            fill: false,
            borderColor: '#fdd3d3',
            data: this.historyCases.deaths
          },
          {
            label: 'Casos recuperados (na cidade)',
            fill: false,
            borderColor: '#cbf1d6',
            data: this.historyCases.cureds
          },
          {
            label: 'Leitos de UTI ocupados (COVID-19)',
            fill: false,
            borderColor: '#fa5252',
            data: this.historyBeds.intensive_care_unit?.covid?.busy
          },
          {
            label: 'Leitos de UTI ocupados (não COVID-19)',
            fill: false,
            borderColor: '#fa5252',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.intensive_care_unit?.normal?.busy
          },
          {
            label: 'Leitos de enfermaria ocupados (COVID-19)',
            fill: false,
            borderColor: '#a3a1fb',
            data: this.historyBeds.nursing?.covid?.busy
          },
          {
            label: 'Leitos de enfermaria ocupados (não COVID-19)',
            fill: false,
            borderColor: '#a3a1fb',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.nursing?.normal?.busy
          },
          {
            label: 'Respiradores ocupados na UTI',
            fill: false,
            borderColor: '#ffb713',
            data: this.historyBeds.intensive_care_unit?.ventilator?.busy
          },
          {
            label: 'Respiradores ocupados na enfermatia',
            fill: false,
            borderColor: '#ffb713',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.nursing?.ventilator?.busy
          }
        ]
      }
    },

    historyChartOptions () {
      return {
        legend: { position: 'bottom' },
        tooltips: { mode: 'index', intersect: false }
      }
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

    hospitalOptions () {
      const { cities } = this.dashboard

      return cities
        ? cities.find(option => option.value === this.city).hospitals
        : []
    },

    hospitals () {
      return this.dashboard.hospitals || []
    },

    hospitalsHeatmap () {
      return this.hospitals.reduce((hospitals, value) => {
        for (let index = 0; index < value.busy; index++) {
          hospitals.push([value.latitude, value.longitude, 1])
        }

        return hospitals
      }, [])
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

    badgesPercent ({ busy, total }) {
      return this.formatPercent((busy / total) || 0)
    },

    clearHospital () {
      this.hospital = ''
    },

    fetch () {
      return this.fetchDashboard({ ...this.$route.query, city: this.$route.params.index })
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

    formatPercent (number) {
      const { format } = new Intl.NumberFormat('pt-BR', {
        style: 'percent',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      })

      return format(number)
    },

    setSelect () {
      this.city = this.$route.params.index || 'ribeirao-preto'
      this.hospital = this.$route.query.hospital || ''
    },

    sumArrays (first, second) {
      return first.map((item, index) => item + second[index])
    },

    updatedDate (model) {
      model = this.dashboard[model]
      return model ? this.formatDateTime(new Date(model.updated_at)) : ''
    },

    updatedDistance (model) {
      model = this.dashboard[model]

      if (model && model.updated_at) {
        const distance = formatDistanceToNow(
          new Date(model.updated_at),
          { locale: ptBR }
        )

        return `Atualizado há ${distance}`
      }

      return 'Não há dados'
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
}

@include breakpoint(min-width $small-screen) {
  .beds {
    &__content {
      & + & {
        border-left: 1px solid $tertiary-color;
      }
    }
  }
}

@include breakpoint($medium-screen) {
  .hospitals-header {
    &__title {
      text-align: right;
    }
  }

  .reverse-row-lg {
    flex-direction: row-reverse;
  }
}

</style>
