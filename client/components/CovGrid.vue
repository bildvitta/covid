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
        'cov-grid--with-gutter': this.gutter
      }
    }
  }
}
</script>

<style lang="scss">
$grid-gutter: 25px !default;

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
}
</style>
