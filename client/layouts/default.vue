<template>
  <div class="default-layout">
    <header class="header">
      <div class="container">
        <h1 class="header__brand">
          COVID-19
        </h1>

        <div class="header__title">
          Ocupação de leitos hospitalares
        </div>

        <div class="header__select">
          <cov-multi-select v-if="fetchSuccess" v-model="city" :allow-empty="true" deselect-label label="label" :options="dashboard.cities" placeholder :searchable="false" select-label selected-label style="width: 300px;" track-by="value" @input="filter()" />
        </div>
      </div>
    </header>

    <main class="main">
      <nuxt />
    </main>

    <footer class="footer">
      <div class="container">
        Este é um projeto <em>open source</em> feito com <img alt="coração" class="heart" src="~/assets/images/heart.svg" style="height: 16px;"> pelo time da <img alt="coração" src="~/assets/images/nave.svg" style="height: 14px;">.
        <div>Acesse ao código-fonte na íntegra <a href="https://github.com/bildvitta/covid" target="_blank">aqui</a>.</div>
      </div>
    </footer>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import CovMultiSelect from '../components/CovMultiSelect'

import { EventBus } from '../helpers/EventBus'

export default {
  components: {
    CovMultiSelect
  },

  data () {
    return {
      city: ''
    }
  },

  computed: {
    ...mapGetters({
      dashboard: 'dashboard/dashboard',
      fetchSuccess: 'dashboard/fetchSuccess'
    })
  },

  watch: {
    fetchSuccess (value) {
      value && this.setSelect()
    }
  },

  created () {
    this.fetch()
  },

  methods: {
    ...mapActions({
      fetchDashboard: 'dashboard/fetch'
    }),

    fetch () {
      return this.fetchDashboard({ ...this.$route.query, city: this.$route.params.index })
    },

    filter () {
      EventBus.$emit('clear-hospital')

      return this.city && this.$router.push({ params: { index: this.city.value } })
    },

    setSelect () {
      const cityQuery = this.$route.params.index || 'ribeirao-preto'
      this.city = this.dashboard.cities.find(city => city.value === cityQuery)
    }
  }
}
</script>

<style lang="scss">

@keyframes heartbeat {
  0% {
    transform: scale(0.75);
  }

  20% {
    transform: scale(1);
  }

  40% {
    transform: scale(0.75);
  }

  60% {
    transform: scale(1);
  }

  80% {
    transform: scale(0.75);
  }

  100% {
    transform: scale(0.75);
  }
}

.default-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.header {
  background-color: $white;
  box-shadow: $shadow;
  padding: 20px 0;
  position: relative;
  z-index: 1001;

  .container {
    align-items: center;
    display: flex;
  }

  &__brand,
  &__title {
    text-transform: uppercase;
  }

  &__brand {
    color: $text-color;
    font-size: 32px;
    font-weight: bold;
  }

  &__title {
    color: $primary-color;
    font-size: 16px;
    margin-left: 16px;
  }

  &__select {
    margin-left: auto;
  }

  @include breakpoint (max-width $small-screen) {
    .container {
      flex-direction: column;
    }

    &__title {
      font-size: 22px;
      text-align: center;
    }
  }
}

.main {
  background-color: $secondary-color;
  flex: 1 0 auto;
}

.footer {
  background-color: $secondary-color;
  color: $text-color;
  padding: 30px;
  z-index: 999999;

  .container {
    text-align: center;
  }
}

.heart {
  animation: heartbeat 1.4s infinite;
}
</style>
