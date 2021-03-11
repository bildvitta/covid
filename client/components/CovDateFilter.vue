<template>
  <div>
    <!-- menu -->
    <!-- TODO fazer um botão de menu -->
    <div>
      <!-- TODO criar um formulário -->
      <div class="DateFilter">
        <!-- loop nos imput -->
        <!-- TODO fazer slot -->
        <input v-model="values.startedAt" class="data" placeholder="data inicial">
        <input v-model="values.finishedAt" class="data" placeholder="data final">
      </div>
      <!-- buttons filter -->
      <div class="DateFilter__actions">
        <!-- <cov-button label="filtrar"> -->
        <button @click="clearFilter">Limpar filtros</button>
        <button @click="filter">filtrar</button>
      </div>
    </div>
  </div>
</template>

<script>
// import CovButton from '~/components/CovButton'
import { mapGetters, mapActions } from 'vuex'
export default {
  // components: {
  //   CovButton
  // },

  props: {
    fields: {
      type: Object,
      default: () => ({})
    }
  },

  data () {
    return {
      values: {}
    }
  },

  computed: {
    ...mapGetters({
      error: 'dashboard/error'
    })
  },

  created () {
    this.values = this.fields
  },

  methods: {
    ...mapActions({
      reset: 'dashboard/reset'
    }),

    clearFilter () {
      this.values = {}
      this.$emit('input', this.values)
      this.reset()
    },

    filter () {
      this.$emit('input', this.values)
    }
  }
}
</script>

<style lang="scss">
.DateFilter {
  align-items: center;
  display: flex;
  justify-content: center;
}

.data {
  border-radius: $radius;
  border-style: none;
  box-shadow: $shadow;
  color: $text-color;
  height: 30px;
  padding-left: 20px;
  width: 100%;

  & + & {
    margin-left: 10px;
  }

  &:focus {
    outline: none;
  }
}
</style>
