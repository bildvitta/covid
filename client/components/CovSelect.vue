<template>
  <cov-box class="select">
    <select v-model="model" v-bind="$attrs" class="select__display" v-on="events">
      <option v-for="(option, index) in formattedOptions" :key="index" :value="option.value">
        {{ option.label }}
      </option>
    </select>
  </cov-box>
</template>

<script>
import CovBox from '~/components/CovBox'

export default {
  components: {
    CovBox
  },

  props: {
    options: {
      type: Array,
      default: () => []
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
    events () {
      const { input, ...events } = this.$listeners
      return events
    },

    model: {
      get () {
        return this.mapOptions ? this.value.value : this.value
      },

      set (value) {
        return this.$emit('input', this.mapOptions
          ? this.formattedOptions.find(option => option.value === value)
          : value
        )
      }
    },

    formattedOptions () {
      return this.options.map((option) => {
        if (typeof option === 'object' && !Array.isArray(option)) {
          if (!('label' in option || 'value' in option)) {
            throw new Error('Object option must have label and value.')
          }

          return option
        }

        return { value: option, label: option }
      })
    }
  }
}
</script>

<style lang="scss">
.select {
  padding: 0;
  position: relative;

  &__display {
    align-items: center;
    appearance: none;
    background-image: url('~assets/images/field-arrow.svg');
    background-position: right 15px center;
    background-repeat: no-repeat;
    background-size: 15px;
    border-radius: $radius;
    border-width: 0;
    color: $text-color;
    display: flex;
    justify-content: space-between;
    margin: 0;
    max-width: 100%;
    padding: 15px;
    position: relative;
    transition: box-shadow $animation-time;
    width: 100%;
  }

  &__text {
    height: 20px;
    padding-right: 15px;
  }

  &__options {
    background-color: #fff;
    overflow: hidden;
    padding: 0;
    position: absolute;
    width: 100%;
  }

  &__option {
    color: $text-color;
    padding: 10px;
    transition: background-color $animation-time;

    &:hover {
      background-color: rgba($black, 0.07);
    }
  }
}
</style>
