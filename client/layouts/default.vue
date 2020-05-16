<template>
  <div class="default-layout">
    <header class="header">
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
        Este é um projeto Open Source. Tenha acesso ao código-fonte na íntegra <a href="?" target="_blank">aqui</a>.
      </div>
    </footer>
  </div>
</template>

<style lang="scss">
.default-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.header {
  box-shadow: $shadow;
  padding: 20px 0;

  .container {
    align-items: center;
    display: flex;
    justify-content: space-between;
  }

  &__brand,
  &__title {
    font-weight: bold;
    text-transform: uppercase;
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
}

.footer {
  background-color: $secondary-color;
  color: $text-color;
  padding: 30px;

  .container {
    text-align: center;
  }
}
</style>
