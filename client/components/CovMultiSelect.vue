<template>
  <multiselect v-model="model" v-bind="$attrs" v-on="$listeners">
    <slot v-for="(slot, key) in $slots" :slot="key" :name="key" />
    <template v-for="(slot, key) in $scopedSlots" :slot="key" slot-scope="option">
      <slot v-bind="option" :name="key" />
    </template>
  </multiselect>
</template>

<script>
import Multiselect from 'vue-multiselect'

export default {
  components: {
    Multiselect
  },

  props: {
    value: {
      type: [Object, Array, String],
      default: null
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
  }
}
</script>

<style lang="scss">
@import url('vue-multiselect/dist/vue-multiselect.min.css');

.multiselect {
  & + & {
    margin-top: 30px;
  }

  &__placeholder {
    color: $text-color;
  }

  &__option--highlight,
  &__option--highlight::after,
  &__option--selected,
  &__input::placeholder,
  &__option--group,
  &__option--selected.multiselect__option--highlight,
  &__option--group.multiselect__option--highligh,
  &__option--group.multiselect__option--highlight::after {
    background-color: rgba($melrose, 0.2);
    color: $text-color;
  }

  &__tag,
  &__spinner::after,
  &__spinner::before,
  &__tag-icon:focus,
  &__tag-icon:hover {
    background-color: $text-color;
  }

  &__tag-icon::after {
    color: white;
  }

  &__tags {
    border-radius: $radius;
    box-shadow: $shadow;
    padding-left: 20px;
  }

  &__content-wrapper {
    border-radius: 0 0 $radius $radius;
    box-shadow: $shadow;
  }

  &__option {
    padding: 8px 20px;
  }
}

@include breakpoint(max-width $small-screen) {
  .multiselect__option {
    padding-left: 10px;
    padding-right: 10px;
  }
}
</style>
