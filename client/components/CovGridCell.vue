<template>
  <div v-bind="$attrs" :class="classes">
    <slot />
  </div>
</template>

<script>
const ignore = ['col']

export default {
  props: {
    breakpoints: {
      type: Object,
      default: () => ({})
    }
  },

  computed: {
    defaultBreakpoint () {
      return { col: 'full', sm: '1-of-2', md: '1-of-2', lg: '1-of-2', ...this.breakpoints }
    },

    classes () {
      const classes = []

      for (const key in this.defaultBreakpoint) {
        const breakpoint = ignore.includes(key) ? '' : `-${key}`
        classes.push(`cov-grid-cell-${breakpoint}-${this.defaultBreakpoint[key]}`)
      }

      return classes
    }
  }
}
</script>

<style lang="scss">
@mixin cov-grid-cell($prefix: '') {
  .cov-grid-cell--#{$prefix}1-of-12 {
    flex-basis: auto;
    width: calc(100% / 12);
  }

  .cov-grid-cell--#{$prefix}1-of-10 {
    flex-basis: auto;
    width: 10%;
  }

  .cov-grid-cell--#{$prefix}1-of-8 {
    flex-basis: auto;
    width: 12.5%;
  }

  .cov-grid-cell--#{$prefix}1-of-6,
  .cov-grid-cell--#{$prefix}2-of-12 {
    flex-basis: auto;
    width: calc(100% / 6);
  }

  .cov-grid-cell--#{$prefix}1-of-5,
  .cov-grid-cell--#{$prefix}2-of-10 {
    flex-basis: auto;
    width: 20%;
  }

  .cov-grid-cell--#{$prefix}1-of-4,
  .cov-grid-cell--#{$prefix}2-of-8,
  .cov-grid-cell--#{$prefix}3-of-12 {
    flex-basis: auto;
    width: 25%;
  }

  .cov-grid-cell--#{$prefix}3-of-10 {
    flex-basis: auto;
    width: 30%;
  }

  .cov-grid-cell--#{$prefix}1-of-3,
  .cov-grid-cell--#{$prefix}2-of-6,
  .cov-grid-cell--#{$prefix}4-of-12 {
    flex-basis: auto;
    width: calc(100% / 3);
  }

  .cov-grid-cell--#{$prefix}3-of-8 {
    flex-basis: auto;
    width: 37.5%;
  }

  .cov-grid-cell--#{$prefix}2-of-5,
  .cov-grid-cell--#{$prefix}4-of-10 {
    flex-basis: auto;
    width: 40%;
  }

  .cov-grid-cell--#{$prefix}5-of-12 {
    flex-basis: auto;
    width: calc(100% * 5 / 12);
  }

  .cov-grid-cell--#{$prefix}1-of-2,
  .cov-grid-cell--#{$prefix}2-of-4,
  .cov-grid-cell--#{$prefix}3-of-6,
  .cov-grid-cell--#{$prefix}4-of-8,
  .cov-grid-cell--#{$prefix}5-of-10,
  .cov-grid-cell--#{$prefix}6-of-12 {
    flex-basis: auto;
    width: 50%;
  }

  .cov-grid-cell--#{$prefix}7-of-12 {
    flex-basis: auto;
    width: calc(100% * 7 / 12);
  }

  .cov-grid-cell--#{$prefix}3-of-5,
  .cov-grid-cell--#{$prefix}6-of-10 {
    flex-basis: auto;
    width: 60%;
  }

  .cov-grid-cell--#{$prefix}5-of-8 {
    flex-basis: auto;
    width: 62.5%;
  }

  .cov-grid-cell--#{$prefix}2-of-3,
  .cov-grid-cell--#{$prefix}4-of-6,
  .cov-grid-cell--#{$prefix}8-of-12 {
    flex-basis: auto;
    width: calc(100% * 2 / 3);
  }

  .cov-grid-cell--#{$prefix}7-of-10 {
    flex-basis: auto;
    width: 70%;
  }

  .cov-grid-cell--#{$prefix}3-of-4,
  .cov-grid-cell--#{$prefix}6-of-8,
  .cov-grid-cell--#{$prefix}9-of-12 {
    flex-basis: auto;
    width: 75%;
  }

  .cov-grid-cell--#{$prefix}4-of-5,
  .cov-grid-cell--#{$prefix}8-of-10 {
    flex-basis: auto;
    width: 80%;
  }

  .cov-grid-cell--#{$prefix}5-of-6,
  .cov-grid-cell--#{$prefix}10-of-12 {
    flex-basis: auto;
    width: calc(100% * 5 / 6);
  }

  .cov-grid-cell--#{$prefix}7-of-8 {
    flex-basis: auto;
    width: 87.5%;
  }

  .cov-grid-cell--#{$prefix}9-of-10 {
    flex-basis: auto;
    width: 90%;
  }

  .cov-grid-cell--#{$prefix}11-of-12 {
    flex-basis: auto;
    width: calc(100% * 11 / 12);
  }

  .cov-grid-cell--#{$prefix}fit {
    flex-basis: auto;
  }

  .cov-grid-cell--#{$prefix}fill {
    flex: 1 1 0%;
    flex-basis: 0%;
  }

  .cov-grid-cell--#{$prefix}full {
    width: 100%;
  }
}

@include cov-grid-cell;

@include breakpoint(max-width $small-screen) {
  @include cov-grid-cell('sm-');
}

@include breakpoint($small-screen $medium-screen) {
  @include cov-grid-cell('md-');
}

@include breakpoint($medium-screen) {
  @include cov-grid-cell('lg-');
}
</style>
