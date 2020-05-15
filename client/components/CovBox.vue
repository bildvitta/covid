<template>
  <div v-bind="$attrs" class="cov-box box-shadow">
    <slot />
  </div>
</template>

<style lang="scss">
@import '../assets/styles/settings.scss';

.cov-box {
  border-radius: $radius;
  padding: 20px;
}
</style>
