<template>
  <div class="cov-box box-shadow">
    <slot />
  </div>
</template>

<style lang="scss">
@import '../assets/styles/settings.scss';

.cov-box {
  border-radius: $radius;
  padding: 15px;
}
</style>
