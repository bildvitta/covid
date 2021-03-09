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
    background-image: url(../assets/images/vaccine.png);
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
    height: 400px;
  }
}

@media screen and (max-width: 480px) {
  .cov-section {
    &__vaccine {
      background-image: url(../assets/images/vaccine.png);
      background-position: -440px -90px;
      background-repeat: no-repeat;
      background-size: auto;
      height: 400px;
    }
  }
}

</style>
