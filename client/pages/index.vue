<template>
  <div class="container">
    <CovSelect v-model="model" :options="['teste', 'teste2']">
      <template v-slot:option-teste="{ option }">
        <div>
          {{ option }} Testando slot
        </div>
      </template>
    </CovSelect>

    <div>{{ model }}</div>

    <cov-grid>
      <cov-grid-cell>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Quibusdam ducimus autem minus odit! Cum, maxime quibusdam. Doloribus velit consequatur optio laborum natus neque vel nostrum reiciendis possimus soluta, sequi ipsam.
      </cov-grid-cell>
      <cov-grid-cell>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Quibusdam ducimus autem minus odit! Cum, maxime quibusdam. Doloribus velit consequatur optio laborum natus neque vel nostrum reiciendis possimus soluta, sequi ipsam.
      </cov-grid-cell>
    </cov-grid>
  </div>
</template>

<script>
import CovSelect from './../components/CovSelect'
import CovGrid from './../components/CovGrid'
import CovGridCell from './../components/CovGridCell'

export default {
  components: {
    CovSelect,
    CovGrid,
    CovGridCell
  },

  data () {
    return {
      model: '2'
    }
  }
}
</script>
