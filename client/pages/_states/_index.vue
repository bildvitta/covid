<template>
  <div v-if="fetchSuccess" class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid gutter>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <div class="hospitals-header">
              <h3 class="text-title">Hospitais</h3>
              <div class="text-subtitle">Fonte: Os dados são disponibilizados diretamente dos hospitais responsáveis.</div>
              <cov-multi-select v-model="hospital" :allow-empty="true" class="cov-multiselect m-t-sm" deselect-label label="name" multiple :options="hospitalOptions" placeholder :searchable="false" select-label selected-label track-by="value" @input="filter()">
                <template slot="option" slot-scope="{ option }">
                  <div class="flex no-wrap justify-between items-start">
                    <cov-checkbox :checked="isChecked(option.value)" class="m-r-xs" :class="multiSelectCheckboxClass(option)" />
                    <div class="cov-multiselect__content">
                      <div class="cov-multiselect__content-header flex justify-between items-center">
                        <span class="cov-multiselect__content-title">{{ option.name }}</span>
                        <cov-badge v-if="option.type" color="quaternary" dense outlined>{{ option.type }}</cov-badge>
                      </div>
                      <div v-if="!option.noUpdateLabel" class="text-size-sm">
                        {{ updatedDistance('', option.updated_at) }}
                      </div>
                    </div>
                  </div>
                </template>
              </cov-multi-select>
            </div>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full', lg: 'full' }">
            <div class="m-t-lg">
              <h3 class="text-title">Leitos</h3>

              <div class="text-subtitle">
                <abbr :title="updatedDate('beds')">{{ updatedDistance('beds') }}</abbr>
              </div>
            </div>

            <div class="m-t-md">
              <cov-grid align-center gutter>
                <cov-grid-cell v-for="(item, key) in beds" :key="key" :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
                  <!-- INICIO CARD -->

                  <cov-info-card :percent="percent(item.covid)">
                    <template v-slot:content>
                      <div class="beds__title">{{ bedsTypes[key].label }} <span class="text-caption">COVID-19</span></div>
                      <div class="beds__box m-t-md">
                        <span class="text-black text-bold">Total</span>
                        <span class="text-bold">{{ item.covid.total }}</span>
                      </div>

                      <div class="beds__box">
                        <span class="text-black text-bold">Ocupados</span>
                        <span class="text-bold">{{ item.covid.busy }}</span>
                      </div>

                      <div class="beds__box">
                        <span class="text-black text-bold">Respiradores em uso</span>
                        <span class="text-bold">{{ item.covid.ventilator }}</span>
                      </div>
                    </template>
                  </cov-info-card>
                  <!-- FIM CARD -->

                  <cov-card class="beds__small m-t-md">
                    <cov-grid gutter justify-between>
                      <cov-grid-cell :breakpoints="{ col: 'full' }">
                        <span class="beds__title text-primary">{{ bedsTypes[key].label }}</span>
                        <span class="text-caption m-l-sm">Outros</span>
                      </cov-grid-cell>

                      <cov-grid-cell :breakpoints="{ col: 'full' }" class="beds__content">
                        <div class="beds__box">
                          <span>Total</span>
                          <span class="text-bold text-primary">{{ item.normal.total }}</span>
                        </div>
                        <div class="beds__box">
                          <span>Ocupados</span>
                          <span class="text-bold text-primary">{{ item.normal.busy }}</span>
                        </div>
                        <div class="beds__box">
                          <span>Respiradores em uso</span>
                          <span class="text-bold text-primary">{{ item.normal.ventilator }}</span>
                        </div>
                      </cov-grid-cell>
                    </cov-grid>
                  </cov-card>
                </cov-grid-cell>
              </cov-grid>
            </div>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full' }">
            <h3 class="text-title m-t-lg">Gráfico de leitos</h3>

            <cov-box class="m-t-md">
              <client-only>
                <cov-line-chart :chart-data="historyChartData" :options="historyChartOptions" />
              </client-only>
            </cov-box>
          </cov-grid-cell>
        </cov-grid>

        <div v-if="fetchSuccess" class="m-t-xl p-t-md">
          <h3 class="text-title m-b-md">Mapa de calor dos leitos</h3>
          <cov-heatmap :points="hospitalsHeatmap" />
        </div>
      </div>

      <div class="container">
        <div class="m-t-xl m-l-n-sm">
          <cov-button href="https://documenter.getpostman.com/view/11415346/Szt7BBFH" icon="code" label="Acesso a API" target="_blank" />
          <cov-button icon="table_chart" label="Baixar planilha" @click="download" />
        </div>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid gutter justify-between>
          <!-- <cov-grid-cell :breakpoints="{ col: '1-of-2', sm: 'full', md: 'full' }"> -->
          <cov-grid-cell :breakpoints="{ sm: 'full' }">
            <cov-grid align-bottom gutter>
              <cov-grid-cell :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
                <div>
                  <h3 class="text-title">Número de casos da cidade</h3>
                  <div class="text-size-sm m-b-md">
                    <abbr :title="updatedDate('covid_cases')">{{ updatedDistance('covid_cases') }}</abbr>
                  </div>

                  <cov-grid v-if="dashboard.covid_cases" align-center gutter-small>
                    <cov-grid-cell v-for="(item, key) in dashboard.covid_cases.cases" :key="key" :breakpoints="{ col: '1-of-3', sm: '1-of-3' }">
                      <cov-card :outlined="casesTypes[key].color">
                        <div class="text-size-sm">{{ casesTypes[key].label }}</div>
                        <div class="text-bold text-size-lg" :class="casesTypes[key].classes">{{ formatCases(item) }}</div>
                      </cov-card>
                    </cov-grid-cell>
                  </cov-grid>
                  <span class="m-t-sm text-size-sm">
                    Fonte: <a href="https://brasil.io/" target="_blank">brasil.io</a>
                  </span>
                </div>
              </cov-grid-cell>

              <cov-grid-cell :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
                <div class="m-t-lg">
                  <cov-progress :content="casesProgress" />
                </div>
              </cov-grid-cell>
            </cov-grid>
          </cov-grid-cell>

          <!-- <cov-grid-cell :breakpoints="{ col: '1-of-2', sm: 'full', md: 'full' }">
            <h3 class="text-title">Respiradores</h3>

            <cov-box class="m-t-md">
              <client-only>
                <cov-line-chart :chart-data="ventilatorsChartData" :options="ventilatorsChartOptions" />
              </client-only>
            </cov-box>
          </cov-grid-cell> -->

          <cov-grid-cell :breakpoints="{ sm: 'full' }">
            <h3 class="text-title m-t-lg">Gráfico de evolução de casos</h3>

            <cov-box class="m-t-md">
              <client-only>
                <cov-line-chart :chart-data="casesChartData" :options="casesChartOptions" />
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

import { EventBus } from '../../helpers/EventBus'

import CovBadge from '~/components/CovBadge'
import CovBox from '~/components/CovBox'
import CovButton from '~/components/CovButton'
import CovCard from '~/components/CovCard'
import CovCheckbox from '~/components/CovCheckbox'
import CovGrid from '~/components/CovGrid'
import CovGridCell from '~/components/CovGridCell'
import CovHeatmap from '~/components/CovHeatmap'
import CovInfoCard from '~/components/CovInfoCard'
import CovLineChart from '~/components/CovLineChart'
import CovLoading from '~/components/CovLoading'
import CovMultiSelect from '~/components/CovMultiSelect'
import CovProgress from '~/components/CovProgress'
import CovSection from '~/components/CovSection'

export default {
  components: {
    CovBadge,
    CovBox,
    CovButton,
    CovCard,
    CovCheckbox,
    CovGrid,
    CovGridCell,
    CovHeatmap,
    CovInfoCard,
    CovLineChart,
    CovLoading,
    CovMultiSelect,
    CovProgress,
    CovSection
  },

  validate ({ params }) {
    return params.states === 'sp'
  },

  data () {
    return {
      hospital: [],
      defaultHospitalOptions: [
        { name: 'Todos', value: 'all', noUpdateLabel: true },
        { name: 'Público', value: 'public', noUpdateLabel: true },
        { name: 'Privado', value: 'private', noUpdateLabel: true }
      ]
    }
  },

  computed: {
    ...mapGetters({
      dashboard: 'dashboard/dashboard',
      error: 'dashboard/error',
      fetchSuccess: 'dashboard/fetchSuccess',
      isFetching: 'dashboard/isFetching',
      params: 'dashboard/params'
    }),

    beds () {
      if (this.dashboard.beds) {
        const { updated_at: updatedAt, ventilator, ...beds } = this.dashboard.beds
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
      return {
        labels: this.historyDates,

        datasets: [
          {
            label: 'Confirmados',
            fill: false,
            borderColor: '#a3a1fb',
            data: this.historyCases.total
          },
          {
            label: 'Recuperados',
            fill: false,
            borderColor: '#34c360',
            data: this.historyCases.cureds
          },
          {
            label: 'Óbitos',
            fill: false,
            borderColor: '#fa5252',
            data: this.historyCases.deaths
          }
        ]
      }
    },

    casesChartOptions () {
      return {
        legend: { position: 'bottom' },
        tooltips: { mode: 'index', intersect: false }
      }
    },

    casesProgress () {
      return [
        {
          value: this.dashboard.covid_cases.cases.total,
          color: 'primary',
          label: 'Casos ativos',
          isTotal: true
        },
        {
          value: this.dashboard.covid_cases.cases.cureds,
          color: 'positive',
          label: 'Recuperados'
        },
        {
          value: this.dashboard.covid_cases.cases.deaths,
          color: 'negative',
          label: 'Óbitos'
        }
      ]
    },

    casesTypes () {
      return {
        total: {
          label: 'Confirmados',
          classes: 'text-primary',
          color: 'primary'
        },

        cureds: {
          label: 'Recuperados',
          classes: 'text-positive',
          color: 'positive'
        },

        deaths: {
          label: 'Óbitos',
          classes: 'text-negative',
          color: 'negative'
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
            label: 'UTI',
            fill: false,
            borderColor: '#fa5252',
            data: this.historyBeds.intensive_care_unit?.covid?.busy
          },
          {
            label: 'UTI (não COVID-19)',
            fill: false,
            borderColor: '#fa5252',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.intensive_care_unit?.normal?.busy
          },
          {
            label: 'Enfermaria',
            fill: false,
            borderColor: '#a3a1fb',
            data: this.historyBeds.nursing?.covid?.busy
          },
          {
            label: 'Enfermaria (não COVID-19)',
            fill: false,
            borderColor: '#a3a1fb',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.nursing?.normal?.busy
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
      return [...this.defaultHospitalOptions, ...this.dashboard.hospitals]
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
    },

    ventilatorsChartData () {
      return {
        labels: this.historyDates,

        datasets: [
          {
            label: 'UTI',
            fill: false,
            borderColor: '#ffb713',
            data: this.historyBeds.intensive_care_unit?.covid?.ventilator
          },
          {
            label: 'UTI (não COVID-19)',
            fill: false,
            borderColor: '#ffedc3',
            data: this.historyBeds.intensive_care_unit?.normal?.ventilator
          },
          {
            label: 'Enfermaria',
            fill: false,
            borderColor: '#ffb713',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.nursing?.covid?.ventilator
          },
          {
            label: 'Enfermaria (não COVID-19)',
            fill: false,
            borderColor: '#ffedc3',
            borderDash: [5],
            borderWidth: 1,
            data: this.historyBeds.nursing?.normal?.ventilator
          }
        ]
      }
    },

    ventilatorsChartOptions () {
      return {
        legend: { position: 'bottom' },
        tooltips: { mode: 'index', intersect: false }
      }
    }
  },

  watch: {
    $route (value) {
      this.fetch()
    },

    fetchSuccess (value) {
      value && this.setSelect()
    }
  },

  created () {
    EventBus.$on('clear-hospital', () => {
      this.clearHospital()
      this.filter()
    })
  },

  methods: {
    ...mapActions({
      fetchDashboard: 'dashboard/fetch'
    }),

    badgesPercent ({ busy, total }) {
      return this.formatPercent((busy / total) || 0)
    },

    clearHospital () {
      this.hospital = []
    },

    fetch () {
      return this.fetchDashboard({ ...this.$route.query })
    },

    filter () {
      const toQuery = this.hospital.map(item => item.value).join(',')

      const query = omitBy({ ...this.$route.query, hospital: toQuery }, isEmpty)
      this.$router.push({ query })
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

    percent ({ busy, total }) {
      return (busy / total) || 0
    },

    setSelect () {
      const hospitalsQuery = (this.$route.query.hospital || '').split(',') || []
      this.hospital = this.hospitalOptions.filter((option, index) => hospitalsQuery.includes(option.value))
    },

    sumArrays (first, second) {
      return first.map((item, index) => item + second[index])
    },

    updatedDate (model) {
      model = this.dashboard[model]
      return model ? this.formatDateTime(new Date(model.updated_at)) : ''
    },

    updatedDistance (model, value = false) {
      model = !value && this.dashboard[model]

      if ((model && model.updated_at) || value) {
        const distance = formatDistanceToNow(
          new Date(model.updated_at || value),
          { locale: ptBR }
        )

        return `Atualizado há ${distance}`
      }

      return 'Não há dados'
    },

    formatCases (cases) {
      return cases || '---'
    },

    async download (event) {
      try {
        const { data } = await this.$axios.get('historical-report', { params: this.params })

        this.createLink(data.link)
      } catch (error) {}
    },

    createLink (url) {
      const link = document.createElement('a')

      link.setAttribute('href', url)
      link.setAttribute('download', '')
      link.style.visibility = 'hidden'
      document.body.appendChild(link)
      link.click()

      this.removeLink(link)
    },

    removeLink (link) {
      document.body.removeChild(link)
    },

    isChecked (value) {
      return this.hospital && !!this.hospital.find(item => item.value === value)
    },

    multiSelectCheckboxClass ({ noUpdateLabel }) {
      return !noUpdateLabel ? 'cov-multiselect__checkbox' : ''
    }
  },

  head () {
    return {
      title: 'COVID-19 | Ribeirão Preto | Ocupação de leitos hospitalares'
    }
  }
}
</script>

<style lang="scss">
.cov-multiselect {
  &__checkbox {
    position: relative;
    top: 4px;
  }

  &__content {
    white-space: normal;
    width: calc(100% - 18px);
  }

  &__content-title {
    white-space: normal;
    width: calc(100% - 60px);
  }
}

.beds {
  &__title {
    font-size: 16px;
  }

  &__box {
    display: flex;
    flex-wrap: nowrap;
    justify-content: space-between;
    line-height: 0.8;

    & + & {
      margin-top: 6px;
    }
  }

  &__card {
    border-radius: $radius;
    display: flex;
    flex-direction: column;
    height: 100%;
    justify-content: center;
    max-height: 120px;
    max-width: 120px;
    padding: 16px;
  }

  &__small {
    margin-left: auto;
    margin-right: auto;
    max-width: 80%;
    position: relative;

    &::before {
      background-color: $primary-color;
      content: '';
      display: block;
      height: 16px;
      left: 50%;
      position: absolute;
      top: -16px;
      transform: translateX(-50%);
      width: 1px;
    }
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
</style>
