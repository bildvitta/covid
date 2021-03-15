<template>
  <component :is="tag" v-bind="$attrs" class="cov-button" :href="href" v-on="$listeners">
    <cov-icon class="cov-button__icon" :name="icon" size="1.5em" />

    <span>
      <slot class="cov-button__label">{{ label }}</slot>
    </span>
  </component>
</template>

<script>
import CovIcon from '~/components/CovIcon'

export default {
  components: {
    CovIcon
  },

  props: {
    href: {
      default: '',
      type: String
    },

    icon: {
      default: '',
      type: String
    },

    label: {
      default: '',
      type: String
    }
  },

  computed: {
    tag () {
      return this.href ? 'a' : 'button'
    }
  }
}
</script>

<style lang="scss">
.cov-button {
  appearance: none;
  background-color: transparent;
  border: 0;
  border-radius: $radius;
  color: $text-color;
  cursor: pointer;
  display: inline-block;
  font-family: inherit;
  font-size: 14px;
  outline: none;
  padding: 10px 12px 8px;
  text-decoration: none;
  // text-transform: uppercase;

  &:hover {
    background-color: rgba($primary-color, 0.25);
  }

  &__icon {
    color: $primary-color;
    margin-right: 4px;
    position: relative;
    top: -1px;
    vertical-align: middle;
  }

  &--filter {
    padding: 10px 10px 10px;
    text-align: center;
  }
}
</style>
