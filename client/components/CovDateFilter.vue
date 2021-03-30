<template>
  <div class="cov-date-filter">
    <div class="cov-date-filter__input-date">
      <date-picker v-model="values" class="cov-date-filter__date-picker" :clearable="false" :disabled-date="dateUnavailable" format="DD/MM/YYYY" placeholder="Filtrar por datas" prefix-class="xmx" range value-type="DD/MM/YYYY">
        <template v-if="isMobile" v-slot:footer="{ emit }">
          <div v-for="(item, index) in shortcuts" :key="index" class="column" style="text-align: center;">
            <button class="mx-btn mx-btn-text" @click="dateRangeShortcut(emit, item.days)">
              {{ item.title }}
            </button>
          </div>
        </template>
        <template v-if="!isMobile" v-slot:sidebar="{ emit }">
          <div v-for="(item, index) in shortcuts" :key="index" class="column" style="text-align: center;">
            <button class="mx-btn mx-btn-text" @click="dateRangeShortcut(emit, item.days)">
              {{ item.title }}
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
      <transition name="fade-button">
        <cov-button v-if="values.length" class="cov-button--filter" label="Limpar filtro" @click="clearFilter" />
      </transition>
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

    shortcuts: {
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
      errorMessage: ''
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

    dateRangeShortcut (emit, days) {
      const start = new Date()
      const end = new Date()

      start.setTime(start.getTime() - days * 24 * 3600 * 1000)

      if (days === 'all') {
        const startAll = new Date(this.avaliableDate.started_at_gteq + ':0:0:0:0')
        const endAll = new Date(this.avaliableDate.finished_at_lteq + ':0:0:0:0')

        return emit([startAll, endAll])
      }

      return emit([start, end])
    },

    dateUnavailable (date) {
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

.fade-button-enter-active,
.fade-button-leave-active {
  transition: opacity 1s;
}

.fade-button-enter,
.fade-button-leave-to {
  opacity: 0;
  transform: translateY(0);
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
