<template>
  <select v-model="model" v-bind="$attrs" v-on="$listeners">
    <!-- <slot v-for="(option, index) in formattedOptions" :name="`option-${option.value}`" :option="option">
      <option :key="index" :value="option.value">
        {{ option.label }}
      </option>
    </slot> -->
    <option v-for="(option, index) in formattedOptions" :key="index" :value="option.value">
      {{ option.label }}
    </option>
  </select>
</template>

<script>
export default {
  props: {
    options: {
      type: Array,
      default: () => ([])
    },

    mapOptions: {
      type: Boolean
    },

    value: {
      type: [String, Number, Object],
      default: ''
    }
  },

  computed: {
    model: {
      get () {
        return this.value
      },

      set (value) {
        const mapOption = this.formattedOptions.find(option => option.value === value)

        return this.$emit('input', this.mapOptions ? mapOption : value)
      }
    },

    formattedOptions () {
      return this.options.map((option) => {
        if (typeof option === 'object' && !Array.isArray(option)) {
          if ((!option.label || option.value)) {
            throw new Error('Object option must have label and value')
          }

          return option
        }

        return { value: option, label: option }
      })
    }
  }
}
</script>
