<template>
  <div class="cov-date-filter">
    <div class="cov-date-filter__input-date">
      <date-picker v-if="!isMobile" v-model="values" class="cov-date-filter__date-picker" :clearable="false" :disabled-date="notBeforeToday" format="DD/MM/YYYY" placeholder="Filtrar por datas" prefix-class="xmx" range :shortcuts="shortcuts" value-type="DD/MM/YYYY" />
      <!-- mobile -->
      <date-picker v-if="isMobile" v-model="values" class="cov-date-filter__date-picker" :clearable="false" :disabled-date="notBeforeToday" format="DD/MM/YYYY" placeholder="Filtrar por datas" prefix-class="xmx" range value-type="DD/MM/YYYY">
        <template v-slot:footer="{ emit }">
          <div class="column" style="text-align: center;">
            <button class="mx-btn mx-btn-text" @click="someDaysBefore(emit, 3)">
              Últimos 3 dias
            </button>
            <button class="mx-btn mx-btn-text" @click="someDaysBefore(emit, 7)">
              Últimos 7 dias
            </button>
            <button class="mx-btn mx-btn-text" @click="someDaysBefore(emit, 15)">
              Últimos 15 dias
            </button>
            <button class="mx-btn mx-btn-text" @click="someDaysBefore(emit, 30)">
              Últimos 30 dias
            </button>
          </div>
        </template>
      </date-picker>
    </div>
    <div class="text-right m-t-md">
      <transition name="fade">
        <div v-if="hasError" class="cov-date-filter__error m-t-sm text-start">
          {{ errorMessage }}
        </div>
      </transition>
      <cov-button class="cov-button--filter" label="Limpar filtro" @click="clearFilter" />
    </div>
    <div />
  </div>
</template>

<script>
import DatePicker from 'vue2-datepicker'
import CovButton from '~/components/CovButton'

import 'vue2-datepicker/index.css'
import 'vue2-datepicker/locale/pt-br'

export default {
  components: {
    CovButton,
    DatePicker
  },

  props: {
    value: {
      type: Array,
      default: () => []
    },

    avaliableDate: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    return {
      window: {
        width: 0
      },
      values: [],
      hasError: false,
      errorMessage: '',
      shortcuts: [
        {
          text: 'Últimos 3 dias',
          onClick () {
            const start = new Date()
            const end = new Date()
            start.setTime(start.getTime() - 3 * 24 * 3600 * 1000)
            const date = [start, end]
            return date
          }
        },
        {
          text: 'Últimos 7 dias',
          onClick () {
            const start = new Date()
            const end = new Date()
            start.setTime(start.getTime() - 7 * 24 * 3600 * 1000)
            const date = [start, end]
            return date
          }
        },
        {
          text: 'Últimos 15 dias',
          onClick () {
            const start = new Date()
            const end = new Date()
            start.setTime(start.getTime() - 15 * 24 * 3600 * 1000)
            const date = [start, end]
            return date
          }
        },
        {
          text: 'Últimos 30 dias',
          onClick () {
            const start = new Date()
            const end = new Date()
            start.setTime(start.getTime() - 30 * 24 * 3600 * 1000)
            const date = [start, end]
            return date
          }
        }
      ]
    }
  },

  computed: {
    isMobile () {
      return this.window.width < 480
    }
  },

  watch: {
    value: {
      handler (value, oldValue) {
        if (oldValue) {
          this.hasError = false
        }

        this.values = value
      },

      immediate: true
    },

    values: {
      handler (value) {
        this.filter()
      },

      immediate: true
    }
  },

  mounted () {
    window.addEventListener('resize', this.handleResize)
    this.handleResize()
  },

  destroyed () {
    window.removeEventListener('resize', this.handleResize)
  },

  methods: {
    handleResize () {
      this.window.width = window.innerWidth
    },

    someDaysBefore (emit, days) {
      const start = new Date()
      const end = new Date()

      start.setTime(start.getTime() - days * 24 * 3600 * 1000)
      const date = [start, end]

      return emit(date)
    },

    notBeforeToday (date) {
      const startedDate = new Date(this.avaliableDate.started_at_gteq)
      startedDate.setHours(0, 0, 0, 0)

      return date < startedDate || date > new Date(this.avaliableDate.finished_at_lteq + ':0:0:0:0')
    },

    clearFilter () {
      this.values = []
      this.$emit('input', this.values)
      this.hasError = false
      this.$emit('clear-filter', [])
    },

    filter () {
      const values = this.values.filter(Boolean)

      if (values[0] === values[1] && values.length) {
        this.hasError = true
        this.errorMessage = 'A data inicial e a data final não podem ser a mesma.'

        return
      }

      this.hasError = false
      return this.$emit('input', this.values)
    }
  }
}
</script>

<style lang="scss">
$namespace: 'xmx';
$sidebar-margin-left: 130px;

@import '~vue2-datepicker/scss/index.scss';

.xmx-input {
  background-color: #fff;
  border: 1px solid $input-border-color;
  border-radius: $radius;
  border-style: none;
  box-shadow: $shadow;
  box-sizing: border-box;
  color: $input-color;
  display: inline-block;
  font-size: 14px;
  height: 34px;
  line-height: 1.4;
  padding: 6px 30px;
  padding-left: 10px;
  width: 100%;
}

.cov-date-filter {
  &__input-date {
    align-items: center;
    display: flex;
    justify-content: center;
    width: 100%;
  }

  &__date-picker {
    height: 30px;
    width: 100%;

    & + & {
      margin-left: 10px;
    }

    &:focus {
      outline: none;
    }
  }

  &__error {
    color: $red;
    display: flex;
    font-size: 12px;
    justify-content: start;
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-50%);
}
</style>
