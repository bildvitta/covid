<template>
  <div>
    <div>
      <div class="datefilter">
        <date-picker v-model="values" class="datefilter__datepicker" :disabled-date="notBeforeToday" format="DD/MM/YYYY" placeholder="Filtrar por datas" prefix-class="xmx" range value-type="DD/MM/YYYY" />
      </div>
      <div class="text-right m-t-lg justify-between">
        <div v-if="isError" class="error">
          {{ errorMessage }}
        </div>
        <div>
          <cov-button label="Limpar filtro" @click="clearFilter" />
          <cov-button class="cov-button--filter" label="Filtrar" @click="filter" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import DatePicker from 'vue2-datepicker'
import 'vue2-datepicker/index.css'
import CovButton from '~/components/CovButton'
import 'vue2-datepicker/locale/pt-br'

export default {
  components: {
    CovButton,
    DatePicker
  },

  props: {
    avaliableDate: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    return {
      values: {},
      isError: false,
      errorMessage: ''
    }
  },

  methods: {
    ...mapActions({
      reset: 'dashboard/reset'
    }),

    notBeforeToday (date) {
      const today = new Date(this.avaliableDate.started_at_gteq)
      today.setHours(0, 0, 0, 0)
      return date < today || date > new Date(this.avaliableDate.finished_at_lteq + ':0:0:0:0')
    },

    clearFilter () {
      this.values = {}
      this.$emit('input', this.values)
      this.reset()
      this.isError = false
    },

    filter () {
      if (this.values[0] === this.values[1]) {
        if (Object.keys(this.values).length === 0) {
          this.isError = true
          this.errorMessage = 'O campo não pode estar em branco'
          return
        }

        this.isError = true
        this.errorMessage = 'O range de dada está incorreto'
        return
      }

      this.isErro = false
      return this.$emit('input', this.values)
    }
  }
}
</script>

<style lang="scss">

$namespace: 'xmx';

@import '~vue2-datepicker/scss/index.scss';

.datefilter {
  align-items: center;
  display: flex;
  justify-content: center;

  &__datepicker {
    height: 30px;
    // padding-left: 20px;
    width: 100%;

    & + & {
      margin-left: 10px;
    }

    &:focus {
      outline: none;
    }
  }
}

.error {
  animation: show 0.5s linear;
  animation-fill-mode: forwards;
  color: red;
  display: block;
  margin-left: 5px;
  margin-top: 10px;
  position: absolute;
}

@keyframes show {
  0% {
    opacity: 0;
    transform: translateY(-40px);
  }

  100% {
    opacity: 1;
    transform: translateY(-30px);
  }
}

</style>
