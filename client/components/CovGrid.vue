<template>
  <div class="cov-grid" :class="classes">
    <slot />
  </div>
</template>

<script>
export default {
  props: {
    alignCenter: {
      type: Boolean
    },

    alignRight: {
      type: Boolean
    },

    alignMiddle: {
      type: Boolean
    },

    alignBottom: {
      type: Boolean
    },

    justifyBetween: {
      type: Boolean
    },

    fill: {
      type: Boolean
    },

    fit: {
      type: Boolean
    },

    equalHeight: {
      type: Boolean
    },

    gutter: {
      type: Boolean
    },

    gutterMedium: {
      type: Boolean
    },

    gutterLarge: {
      type: Boolean
    }
  },

  computed: {
    classes () {
      return {
        'cov-grid--align-center': this.alignCenter,
        'cov-grid--align-right': this.alignRight,
        'cov-grid--align-middle': this.alignMiddle,
        'cov-grid--align-bottom': this.alignBottom,
        'cov-grid--justify-between': this.justifyBetween,
        'cov-grid--fill': this.fill,
        'cov-grid--fit': this.fit,
        'cov-grid--equal-height': this.equalHeight,
        'cov-grid--with-gutter': this.gutter,
        'cov-grid--with-gutter-md': this.gutterMedium,
        'cov-grid--with-gutter-lg': this.gutterLarge
      }
    }
  }
}
</script>

<style lang="scss">
$grid-gutter: 16px !default;
$grid-gutter-md: 20px !default;
$grid-gutter-lg: 25px !default;

.cov-grid {
  $root: &;

  box-sizing: border-box;
  display: flex;
  flex-wrap: wrap;
  margin: 0;
  padding: 0;

  > * {
    box-sizing: inherit;
    flex-basis: 100%;
    min-width: 0;
  }

  &--align-center {
    justify-content: center;
  }

  &--align-right {
    justify-content: flex-end;
  }

  &--align-middle {
    align-items: center;
  }

  &--align-bottom {
    align-items: flex-end;
  }

  &--justify-between {
    justify-content: space-between;
  }

  &--fill > * {
    flex: 1 1 0%;
  }

  &--fit > * {
    flex-basis: auto;
  }

  &--equal-height > * {
    display: flex;
  }

  &--with-gutter {
    margin: #{ -0.5 * $grid-gutter} #{ -0.5 * $grid-gutter};

    > * {
      padding: #{ 0.5 * $grid-gutter} #{0.5 * $grid-gutter};
    }
  }

  &--with-gutter-md {
    margin: #{ -0.5 * $grid-gutter-md} #{ -0.5 * $grid-gutter-md};

    > * {
      padding: #{ 0.5 * $grid-gutter-md} #{0.5 * $grid-gutter-md};
    }
  }

  &--with-gutter-lg {
    margin: #{ -0.5 * $grid-gutter-lg} #{ -0.5 * $grid-gutter-lg};

    > * {
      padding: #{ 0.5 * $grid-gutter-lg} #{0.5 * $grid-gutter-lg};
    }
  }
}
</style>
