<template>
  <div class="position position--relative">
    <cov-section>
      <div class="container">
        <cov-grid gutter>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '6-of-12' }">
            <cov-grid gutter>
              <form>
                <cov-grid gutter>
                  <cov-grid-cell :breakpoints="{ sm: 'full', md: '1-of-3', lg: '1-of-3' }">
                    <h3 class="typography typography--title">Cidade</h3>
                    <cov-select v-model="city" :options="dashboard.cities" @input="filterCity" />
                  </cov-grid-cell>

                  <cov-grid-cell :breakpoints="{ sm: 'fill', md: 'fill', lg: 'fill' }">
                    <h3 class="typography typography--title">Hospitais</h3>
                    <cov-select v-model="hospital" :options="hospitalOptions" @input="filter" />
                  </cov-grid-cell>
                </cov-grid>
              </form>

              <div class="beds">
                <h3 class="typography typography--title">Leitos</h3>
                <div class="typography typography--subtitle">{{ updatedAt('beds') }}</div>

                <cov-grid gutter>
                  <cov-grid-cell v-for="(item, key) in beds" :key="key" :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
                    <cov-card class="typography">
                      <template v-slot:header>
                        <span class="beds__title">{{ bedsTitle[key] }}</span>
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

              <div>
                <h3 class="typography typography--title">Casos em {{ currentCity }}</h3>
                <div class="typography typography--subtitle">{{ updatedAt('covid_cases') }}</div>
                <cov-grid v-if="dashboard.covid_cases" gutter>
                  <cov-grid-cell v-for="(item, key) in dashboard.covid_cases.cases" :key="key" :breakpoints="{ sm: 'full', md: '1-of-2', lg: '1-of-3' }">
                    <cov-card>
                      <div>{{ covidCases[key].text }}</div>
                      <div class="typography--heavy-text" :class="covidCases[key].color">{{ item }}</div>
                      <client-only>
                        <cov-line-chart :chart-data="historyChartData" />
                      </client-only>
                    </cov-card>
                  </cov-grid-cell>
                </cov-grid>
              </div>

              <div>
                <cov-button icon="table_chart" label="Baixar planilha" @click="download" />
                <cov-button href="#" icon="code" label="Acesso a API" />
              </div>
            </cov-grid>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ col: 'full', sm: 'full', md: 'full', lg: '6-of-12' }">
            <cov-heatmap />
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid gutter justify-between>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <h3 class="typography typography--title">Dashboard 1</h3>
            <cov-box>
              <client-only>
                <cov-line-chart :chart-data="historyChartData" />
              </client-only>
            </cov-box>
          </cov-grid-cell>

          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
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
import { differenceInMinutes, parseISO } from 'date-fns'

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
    },

    beds () {
      if (this.dashboard.beds) {
        const { updated_at: updatedAt, ...beds } = this.dashboard.beds

        return beds
      }

      return {}
    },

    bedsTitle () {
      return {
        intensive_care_unit: 'UTI',
        nursing: 'Enfernmagem',
        ventilator: 'Respiradores'
      }
    },

    covidCases () {
      return {
        total: { text: 'Casos totais', color: 'text-primary' },
        deaths: { text: 'Mortes', color: 'text-negative' },
        cureds: { text: 'Recuperados', color: 'text-positive' }
      }
    },

    currentCity () {
      return this.dashboard.cities ? this.dashboard.cities.find(city => city.value === this.city).label : ''
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
    differenceInMinutes,
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
    },

    download () {
      const url = 'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png'
      const link = document.createElement('a')
      link.setAttribute('href', url)
      link.setAttribute('download', '')
      link.style.visibility = 'hidden'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
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
