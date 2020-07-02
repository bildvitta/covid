<template>
  <input v-model="model" v-bind="$attrs" class="cov-checkbox" type="checkbox" v-on="$listeners">
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean
    }
  },

  computed: {
    model: {
      get () {
        return this.value
      },

      set (value) {
        return this.$emit('input', value)
      }
    }
  },

  watch: {
    '$attrs.checked' (value) {
      this.$el.classList.toggle('js-checked', value)
    }
  },

  mounted () {
    if (this.$attrs.checked) {
      this.$el.classList.add('js-checked')
    }
  }
}
</script>

<style lang="scss">
.cov-checkbox {
  -moz-appearance: none;
  -o-appearance: none;
  -webkit-appearance: none;
  background-color: white;
  border: 1px solid $text-color;
  border-radius: 1px;
  cursor: pointer;
  height: 16px;
  outline: 0;
  width: 16px;

  &.js-checked,
  &:checked {
    background-image: url('../assets/images/check.svg');
    background-position: center;
    background-size: 14px;
  }
}
</style>
