<template>
  <div class="cov-date-filter">
    <div class="cov-date-filter__input-date">
      <date-picker v-model="values" class="cov-date-filter__date-picker" :clearable="false" :disabled-date="notBeforeToday" format="DD/MM/YYYY" placeholder="Filtrar por datas" prefix-class="xmx" range value-type="DD/MM/YYYY" />
    </div>
    <div>
      <transition name="fade">
        <div v-if="hasError" class="cov-date-filter__error m-t-sm">
          {{ errorMessage }}
        </div>
      </transition>
      <div class="text-right justify-between m-t-sm">
        <cov-button label="Limpar filtro" @click="clearFilter" />
        <cov-button class="cov-button--filter" label="Filtrar" @click="filter" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
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
      values: [],
      hasError: false,
      errorMessage: ''
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

  methods: {
    ...mapActions({
      reset: 'dashboard/reset'
    }),

    notBeforeToday (date) {
      const startedDate = new Date(this.avaliableDate.started_at_gteq)
      startedDate.setHours(0, 0, 0, 0)

      return date < startedDate || date > new Date(this.avaliableDate.finished_at_lteq + ':0:0:0:0')
    },

    clearFilter () {
      this.values = []
      this.$emit('input', this.values)
      this.hasError = false
    },

    filter () {
      const values = this.values.filter(Boolean)

      if (values[0] === values[1]) {
        this.hasError = true
        this.errorMessage = Object.keys(values).length
          ? 'A data inicial e a data final não podem ser a mesma.'
          : 'Selecione uma data.'

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

@import '~vue2-datepicker/scss/index.scss';

.cov-date-filter {
  &__input-date {
    align-items: center;
    display: flex;
    justify-content: center;
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
    // animation: show 0.5s linear;
    // animation-fill-mode: forwards;
    color: $red;
    font-size: 12px;
    // display: block;
    // margin-left: 5px;
    // margin-top: 10px;
    // position: absolute;
  }
}

.fade-enter-active,
.fade-leave-active {
  // transform: translateY(100%);
  transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-100%);
}

@keyframes show {
  0% {
    opacity: 0;
    transform: translateY(-40px);
  }

  100% {
    opacity: 1;
    transform: translateY(100%);
  }
}
</style>
