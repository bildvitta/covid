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
      return { col: 'Full', sm: '1of2', md: '1of2', lg: '1of2', ...this.breakpoints }
    },

    classes () {
      const classes = []

      for (const key in this.defaultBreakpoint) {
        const breakpoint = ignore.includes(key) ? '' : `${key}-`

        classes.push(`${breakpoint}size${this.defaultBreakpoint[key]}`)
      }

      return classes
    }
  }
}
</script>

<style lang="scss">
@import '../node_modules/breakpoint-sass/stylesheets/_breakpoint';

@mixin cov-grid-cell($prefix: '') {
  .#{$prefix}size1of12 {
    flex-basis: auto;
    width: calc(100% / 12);
  }

  .#{$prefix}size1of10 {
    flex-basis: auto;
    width: 10%;
  }

  .#{$prefix}size1of8 {
    flex-basis: auto;
    width: 12.5%;
  }

  .#{$prefix}size1of6,
  .#{$prefix}size2of12 {
    flex-basis: auto;
    width: calc(100% / 6);
  }

  .#{$prefix}size1of5,
  .#{$prefix}size2of10 {
    flex-basis: auto;
    width: 20%;
  }

  .#{$prefix}size1of4,
  .#{$prefix}size2of8,
  .#{$prefix}size3of12 {
    flex-basis: auto;
    width: 25%;
  }

  .#{$prefix}size3of10 {
    flex-basis: auto;
    width: 30%;
  }

  .#{$prefix}size1of3,
  .#{$prefix}size2of6,
  .#{$prefix}size4of12 {
    flex-basis: auto;
    width: calc(100% / 3);
  }

  .#{$prefix}size3of8 {
    flex-basis: auto;
    width: 37.5%;
  }

  .#{$prefix}size2of5,
  .#{$prefix}size4of10 {
    flex-basis: auto;
    width: 40%;
  }

  .#{$prefix}size5of12 {
    flex-basis: auto;
    width: calc(100% * 5 / 12);
  }

  .#{$prefix}size1of2,
  .#{$prefix}size2of4,
  .#{$prefix}size3of6,
  .#{$prefix}size4of8,
  .#{$prefix}size5of10,
  .#{$prefix}size6of12 {
    flex-basis: auto;
    width: 50%;
  }

  .#{$prefix}size7of12 {
    flex-basis: auto;
    width: calc(100% * 7 / 12);
  }

  .#{$prefix}size3of5,
  .#{$prefix}size6of10 {
    flex-basis: auto;
    width: 60%;
  }

  .#{$prefix}size5of8 {
    flex-basis: auto;
    width: 62.5%;
  }

  .#{$prefix}size2of3,
  .#{$prefix}size4of6,
  .#{$prefix}size8of12 {
    flex-basis: auto;
    width: calc(100% * 2 / 3);
  }

  .#{$prefix}size7of10 {
    flex-basis: auto;
    width: 70%;
  }

  .#{$prefix}size3of4,
  .#{$prefix}size6of8,
  .#{$prefix}size9of12 {
    flex-basis: auto;
    width: 75%;
  }

  .#{$prefix}size4of5,
  .#{$prefix}size8of10 {
    flex-basis: auto;
    width: 80%;
  }

  .#{$prefix}size5of6,
  .#{$prefix}size10of12 {
    flex-basis: auto;
    width: calc(100% * 5 / 6);
  }

  .#{$prefix}size7of8 {
    flex-basis: auto;
    width: 87.5%;
  }

  .#{$prefix}size9of10 {
    flex-basis: auto;
    width: 90%;
  }

  .#{$prefix}size11of12 {
    flex-basis: auto;
    width: calc(100% * 11 / 12);
  }

  .#{$prefix}sizeFit {
    flex-basis: auto;
  }

  .#{$prefix}sizeFill {
    flex: 1 1 0%;
    flex-basis: 0%;
  }

  .#{$prefix}sizeFull {
    width: 100%;
  }
}

@include cov-grid-cell;

@include breakpoint('480px') {
  @include cov-grid-cell('sm-');
}

@include breakpoint('768px') {
  @include cov-grid-cell('md-');
}

@include breakpoint('1080px') {
  @include cov-grid-cell('lg-');
}
</style>
