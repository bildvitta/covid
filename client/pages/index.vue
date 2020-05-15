<template>
  <div class="container">
    <CovSelect v-model="model" map-options :options="[{ label: 'teste', value: 1 }, { label: 'teste2', value: 2 }]">
      <!-- <template v-slot:option-teste="{ option }">
        <div>
          {{ option }} Testando slot
        </div>
      </template> -->
    </CovSelect>

    <div>{{ model }}</div>

    <cov-grid>
      <cov-grid-cell>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Quibusdam ducimus autem minus odit! Cum, maxime quibusdam. Doloribus velit consequatur optio laborum natus neque vel nostrum reiciendis possimus soluta, sequi ipsam.
      </cov-grid-cell>
      <cov-grid-cell>
        <cov-box>
          Lorem ipsum dolor sit amet consectetur adipisicing elit. Quibusdam ducimus autem minus odit! Cum, maxime quibusdam. Doloribus velit consequatur optio laborum natus neque vel nostrum reiciendis possimus soluta, sequi ipsam.
        </cov-box>
      </cov-grid-cell>
    </cov-grid>

    <CovBadge>100%</CovBadge>
    <CovBadge color="negative">12,5%</CovBadge>
    <CovBadge color="positive">89,14%</CovBadge>
    <CovBadge color="warning">67,5%</CovBadge>
  </div>
</template>

<script>
import CovBadge from './../components/CovBadge'
import CovGrid from './../components/CovGrid'
import CovGridCell from './../components/CovGridCell'
import CovSelect from './../components/CovSelect'
import CovBox from './../components/CovBox'

export default {
  components: {
    CovBadge,
    CovGrid,
    CovGridCell,
    CovSelect,
    CovBox
  },

  data () {
    return {
      model: '2'
    }
  }
}
</script>
