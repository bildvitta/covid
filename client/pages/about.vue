<template>
  <div class="page-about">
    <cov-section class="page-about">
      <div class="container">
        <div class="page-about__back-btn inline-flex items-center justify-between m-b-xl"
             @click="goToHome"
        >
          <cov-icon class="cov-button__icon" name="arrow_back" size="1.4em" />
          <span class="m-l-sm text-size-md">voltar</span>
        </div>

        <cov-grid gutter-large>
          <h3 class="text-title text-transform-initial text-size-xl">Sobre o projeto</h3>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <span class="page-about__description-text m-b-lg">
              A plataforma Leitos Covid é uma iniciativa desenvolvida com o propósito único e exclusivo de contribuir, de forma genuína, com esse momento de pandemia no qual todos estamos imersos.
            </span>

            <span class="page-about__description-text m-b-lg">
              O projeto foi estruturado em parceria com os principais hospitais públicos e privados e Secretaria de Saúde do município de Ribeirão Preto.
            </span>

            <span class="page-about__description-text m-b-lg">
              Com o objetivo de ser útil tanto para o gestor público quanto para a população, a plataforma Leitos Covid mostra, em tempo real, a quantiadde de leitos disponíveis no município e qual é a sua taxa de ocupação.
            </span>

            <span class="page-about__description-text">
              Construída de maneira open source para que também outros municípios possam utilizar, ressaltamos que é uma integração pela qual torcemos muito para que seja realizada por outras prefeituras do estado de São Paulo e do Brasil.
            </span>
          </cov-grid-cell>
          <cov-grid-cell :breakpoints="{ sm: 'full', md: 'full', lg: '1-of-2' }">
            <img alt="Leitos Covid - Sobre" class="page-about__image"
                 src="~/assets/images/about-section-img.png"
            >
          </cov-grid-cell>
        </cov-grid>
      </div>
    </cov-section>

    <cov-section class="cov-section--melrose">
      <div class="container">
        As informações aqui fornecidas são unicamente para assistência e fins informativos e não devem ser aplicadas para um fim específico, ou utilizadas em substituição de assistência médica. Embora tentemos abordar inteiramente determinados tópicos, não é possível apresentar todas as situações existentes e suas particularidades, nem garantir que todas as informações fornecidas estejam atualizadas, estando sujeitas à atrasos e erros. As informações, opiniões e pontos de vista aqui expressos são exclusivos daquele que as emitiu, não refletindo as opiniões dos desenvolvedores da página. Toda a responsabilidade relativa às ações tomadas, ou não tomadas, relacionadas ao aqui disposto, estão afastadas. Consulte um médico ou plano de saúde para respostas.
      </div>
    </cov-section>
  </div>
</template>

<script>
import CovSection from '~/components/CovSection'
import CovGrid from '~/components/CovGrid'
import CovGridCell from '~/components/CovGridCell'
import CovIcon from '~/components/CovIcon'

export default {
  components: {
    CovSection,
    CovGrid,
    CovGridCell,
    CovIcon
  },

  methods: {
    goToHome () {
      this.$router.push('/')
    }
  }
}
</script>

<style lang="scss">
  .page-about {
    &__description-text {
      display: block;
      line-height: $line-height;
    }

    &__image {
      width: 100%;
    }

    .cov-section--melrose {
      padding: 30px 0;

      .container {
        line-height: $line-height;
      }
    }

    &__back-btn {
      cursor: pointer;

      .cov-button__icon,
      span {
        color: $melrose;
      }
    }
  }
</style>
