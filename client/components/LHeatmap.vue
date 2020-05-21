<template>
  <div style="display: none;">
    <slot v-if="ready" />
  </div>
</template>

<script>
const component = {}

if (process.client) {
  const L = require('leaflet')
  const { findRealParent, propsBinder } = require('vue2-leaflet')

  require('leaflet.heat')

  const props = {
    blur: {
      custom: true,
      default: 15,
      type: Number
    },

    latLng: {
      custom: false,
      default: () => [],
      type: Array
    },

    minOpacity: {
      custom: true,
      default: 0.05,
      type: Number
    },

    maxZoom: {
      custom: true,
      default: 18,
      type: Number
    },

    radius: {
      custom: true,
      default: 25,
      type: Number
    },

    max: {
      custom: true,
      default: 1.0,
      type: Number
    },

    visible: {
      custom: true,
      default: true,
      type: Boolean
    }
  }

  component.props = props

  component.data = function () {
    return { ready: false }
  }

  component.mounted = function () {
    const options = {}

    if (this.minOpacity) {
      options.minOpacity = this.minOpacity
    }

    if (this.maxZoom) {
      options.maxZoom = this.maxZoom
    }

    if (this.radius) {
      options.radius = this.radius
    }

    if (this.blur) {
      options.blur = this.blur
    }

    if (this.max) {
      options.max = this.max
    }

    this.mapObject = L.heatLayer(this.latLng, options)

    L.DomEvent.on(this.mapObject, this.$listeners)
    propsBinder(this, this.mapObject, props)

    this.ready = true

    this.parentContainer = findRealParent(this.$parent)
    this.parentContainer.addLayer(this, !this.visible)
  }

  component.beforeDestroy = function () {
    this.parentContainer.removeLayer(this)
  }

  component.methods = {
    setMinOpacity (value) {
      this.mapObject.setOptions({ minOpacity: value })
    },

    setMaxZoom (value) {
      this.mapObject.setOptions({ maxZoom: value })
    },

    setRadius (value) {
      this.mapObject.setOptions({ radius: value })
    },

    setBlur (value) {
      this.mapObject.setOptions({ blur: value })
    },

    setMax (value) {
      this.mapObject.setOptions({ max: value })
    },

    setVisible (current, old) {
      if (current === old) {
        return
      }

      current
        ? this.parentContainer.addLayer(this)
        : this.parentContainer.removeLayer(this)
    },

    addLatLng (value) {
      this.mapObject.addLatLng(value)
    }
  }
}

export default component
</script>
