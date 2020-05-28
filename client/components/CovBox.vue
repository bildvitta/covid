<template>
  <div class="cov-box">
    <slot />
  </div>
</template>

<style lang="scss">
.cov-box {
  $root: &;

  border-radius: $radius;
  padding: 15px;
  width: 100%;

  &:not(&--flat) {
    box-shadow: $shadow;
  }

  &:not(&--outlined) {
    background-color: $white;
  }

  &--negative {
    &#{$root}--outlined {
      border-color: $negative-color;
    }
  }

  &--positive {
    &#{$root}--outlined {
      border-color: $positive-color;
    }
  }

  &--warning {
    &#{$root}--outlined {
      border-color: $warning-color;
    }
  }

  &--outlined {
    background: transparent;
    border-style: solid;
    border-width: 1px;
  }
}
</style>
