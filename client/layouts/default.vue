<template>
  <div>
    <header class="header box-shadow">
      <div class="container">
        <div class="header__brand">
          covid-19
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
        Este é um projeto Open Source. Tenha <a href="?" target="_blank">acesso ao código-fonte na íntegra</a>.
      </div>
    </footer>
  </div>
</template>

<style lang="scss">
@import '../assets/styles/settings.scss';

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
    font-size: 38px;
  }

  &__title {
    color: $primary-color;
    font-size: 32px;
  }
}
</style>
