<template>
  <div>
    <cov-box class="select">
      <select v-model="model" v-bind="$attrs" class="select__display" v-on="$listeners">
        <option v-for="(option, index) in formattedOptions" :key="index" :value="option.value">
          {{ option.label }}
        </option>
      </select>
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
          if (!('label' in option || 'value' in option)) {
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
    padding: 0;
    position: relative;

    &__display {
      align-items: center;
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

      // &::after {
      //   background-image: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPgo8c3ZnIGlkPSJTX0Ryb3Bkb3duXzEwX04iIHZpZXdCb3g9IjAgMCAxMCAxMCIgdmVyc2lvbj0iMS4xIgoJeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIKCXg9IjBweCIgeT0iMHB4IiB3aWR0aD0iMTBweCIgaGVpZ2h0PSIxMHB4Igo+Cgk8ZyBpZD0iTGF5ZXIlMjAxIj4KCQk8ZyBpZD0iU19Ecm9wZG93bl8xMF9OX2x0Ij4KCQkJPHBhdGggZD0iTSA1LjUyNTkgNy40NzUzIEwgOC43MDggNC4yOTM1IEMgOS4wMDEgNC4wMDA1IDkuMDAxIDMuNTI1NiA4LjcwOCAzLjIzMjkgQyA4LjQxNSAyLjkzOTkgNy45NDAyIDIuOTM5OSA3LjY0NzIgMy4yMzI5IEwgNC45OTU2IDUuODg0NSBMIDIuMzQ0IDMuMjMyOSBDIDIuMDUxIDIuOTM5OSAxLjU3NjIgMi45Mzk5IDEuMjgzMiAzLjIzMjkgQyAwLjk5MDIgMy41MjU2IDAuOTkwMiA0LjAwMDUgMS4yODMyIDQuMjkzNSBMIDQuNDY1MyA3LjQ3NTMgQyA0Ljc1ODMgNy43NjgzIDUuMjMyOSA3Ljc2ODMgNS41MjU5IDcuNDc1MyBaIiBmaWxsPSIjNjY2NjY2Ii8+CgkJPC9nPgoJPC9nPgo8L3N2Zz4=);
      //   background-position: center;
      //   background-size: 100%;
      //   content: "";
      //   height: 7px;
      //   position: absolute;
      //   right: 15px;
      //   width: 10px;
      // }
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
