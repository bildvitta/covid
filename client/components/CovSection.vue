<template>
  <section class="cov-section" :class="classes">
    <slot />
  </section>
</template>

<script>
export default {
  props: {
    color: {
      default: '',
      type: String
    }
  },

  computed: {
    classes () {
      const classes = []

      if (this.color) {
        classes.push(`cov-section--${this.color}`)
      }

      return classes
    }
  }
}
</script>

<style lang="scss">
.cov-section {
  padding: 60px 0;

  &--melrose {
    background-color: rgba($melrose, 0.2);
  }

  &__vaccine {
    background-image: linear-gradient(rgba(255, 255, 255, 0.4), rgba(255, 255, 255, 0)), url(../assets/images/vaccine.png);
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
    min-height: 400px;
  }
}

@media screen and (max-width: 480px) {
  .cov-section {
    &__vaccine {
      background-image: linear-gradient(rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 0.6)), url(../assets/images/vaccine.png);
      background-position: center;
      background-repeat: no-repeat;
      background-size: auto;
      min-height: 400px;
    }
  }
}

</style>
