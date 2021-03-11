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
        <input v-model="values.finishedAt" class="data" placeholder="data final" @input="filter">
      </div>
    </div>
    <!-- buttons filter -->
    <!-- <div>
      <button @click="clearFilter">Limpar filtros</button>
      <button @click="filter">filtrar</button>
    </div> -->
  </div>
</template>

<script>

export default {
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

  created () {
    this.values = this.fields
  },

  methods: {
    clearFilter () {
      this.values = {}
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
