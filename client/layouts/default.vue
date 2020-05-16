<template>
  <div class="defaut">
    <header class="header box-shadow">
      <div class="container">
        <div class="header__brand">
          Covid-19
        </div>

        <div class="header__title">
          Ocupação de leitos hospitalares
        </div>
      </div>
    </header>

    <main class="main">
      <div class="container">
        <nuxt />
      </div>
    </main>

    <footer class="footer">
      <div class="container">
        Este é um projeto Open Source. Tenha acesso ao código-fonte na íntegra <a href="?" target="_blank">aqui</a>.
      </div>
    </footer>
  </div>
</template>

<style lang="scss">
@import '../assets/styles/settings.scss';

.defaut {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  padding: 40px 0;

  .container {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  &__brand,
  &__title {
    text-transform: uppercase;
    font-weight: bold;
  }

  &__brand {
    color: $text-color;
    font-size: 40px;
  }

  &__title {
    color: $primary-color;
    font-size: 32px;
  }
}

.main {
  flex: 1 0 auto;
  background-color: $secondary-color;
}

.footer {
  padding: 30px;
  background-color: $secondary-color;
  color: $text-color;

  .container {
    text-align: center;
  }
}
</style>
