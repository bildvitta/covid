<template>
  <div class="cov-grid">
    <slot />
  </div>
</template>

<style lang="scss">
$grid-gutter: 25px !default;

.cov-grid {
  $root: &;

  box-sizing: border-box;
  display: flex;
  flex-direction: row;
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
