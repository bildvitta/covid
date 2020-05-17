<template>
  <div>
    <cov-section>
      <div class="container">
        <cov-grid>
          <cov-grid-cell>
            <form action="">
              Formulário
            </form>

            <div>
              <h3 class="typography--title">Leitos</h3>
              <div class="typography--subtitle">Atualizado há 10 min</div>

              <CovBadge>100%</CovBadge>
              <CovBadge color="negative">12,5%</CovBadge>
              <CovBadge color="positive">89,14%</CovBadge>
              <CovBadge color="warning">67,5%</CovBadge>
            </div>

            <div>
              <h3 class="typography--title">Casos em Ribeirão Preto</h3>
              <div class="typography--subtitle">Atualizado há 10 min</div>

              <cov-card>
                Card
              </cov-card>
            </div>

            <div>
              Botões
            </div>
          </cov-grid-cell>
          <cov-grid-cell>
            <cov-heatmap />
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-section color="melrose">
      <div class="container">
        <cov-grid>
          <cov-grid-cell>
            <h3 class="typography typography--title">Dashboard 1</h3>
            <cov-box>
              Gráfico 1
            </cov-box>
          </cov-grid-cell>

          <cov-grid-cell>
            <h3 class="typography typography--title">Dashboard 2</h3>
            <cov-box>
              Gráfico 2
            </cov-box>
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>
  </div>
</template>

<script>
import CovBadge from '~/components/CovBadge'
import CovBox from '~/components/CovBox'
import CovCard from '~/components/CovCard'
import CovGrid from '~/components/CovGrid'
import CovGridCell from '~/components/CovGridCell'
import CovHeatmap from '~/components/CovHeatmap'
import CovSection from '~/components/CovSection'

export default {
  components: {
    CovBadge,
    CovBox,
    CovCard,
    CovGrid,
    CovGridCell,
    CovHeatmap,
    CovSection
  }

  // data () {
  //   return {}
  // }
}
</script>
