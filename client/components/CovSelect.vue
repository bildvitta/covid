<template>
  <div>
    <!-- <cov-box class="select">
      <select v-model="model" v-bind="$attrs" class="select__select" v-on="$listeners">
        <option v-for="(option, index) in formattedOptions" :key="index" :value="option.value">
          {{ option.label }}
        </option>
      </select>
    </cov-box> -->

    <cov-box class="select">
      <select v-model="model" v-bind="$attrs" class="select__select" v-on="$listeners">
        <option v-for="(option, index) in formattedOptions" :key="index" :value="option.value">
          {{ option.label }}
        </option>
      </select>

      <div class="select__display">{{ "Text selected" }}</div>
    </cov-box>

    <cov-box v-if="show" class="select__options">
      <div v-for="(option, index) in formattedOptions" :key="index" class="select__option" :value="option.value">
        {{ option.label }}
      </div>
    </cov-box>
  </div>
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
          if ((!option.label || !option.value)) {
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

<style lang="scss">
  .select {
    &__select {
      display: none;
      opacity: 0;
      visibility: hidden;
    }

    &__display {
      border-radius: $radius;
      border-width: 0;
      color: $text-color;
      display: flex;
      margin: 0;
      max-width: 100%;
      transition: box-shadow $animation-time;
      width: 100%;

      // &::after {
      //   background-color: red;
      //   content: '';
      //   display: inline-block;
      //   height: 10px;
      //   width: 10px;
      // }
    }

    &__options {
      background-color: #fff;
    }

    &__option {
      color: $text-color;
      transition: background-color $animation-time;

      &:hover {
        background-color: rgba($black, 0.07);
      }
    }
  }
</style>
