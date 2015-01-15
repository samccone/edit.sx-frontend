App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Footer extends Marionette.LayoutView
    template: templates.footer

    regions: ->
      'filterRegion':
        selector: '.filter-container'
        viewClass: Views.EditFilter
        viewOptions: => model: @filterModel

      'filterColorRegion':
        selector: '.color-hold'
        viewClass: Views.EditColorFilter
        viewOptions: => model: @filterModel

    behaviors:
      AutoRegion: {}

    initialize: ->
      @filterModel = new App.Models.EditImage()
      @tinySnap = 0.75
      @imageSizeBase =
        height: 157
        width: 195

      @filterModel.on 'change', @updateFilter

      App.reqres.setHandler "filter", => @filterModel

    _getImageStyle: _.memoize ->
      rules = document.styleSheets[0].cssRules || document.styleSheets[0].rules
      _.findWhere(rules, {selectorText: '.single-image'})

    updateFilter: ->
      App.reqres.setHandler "filtered", => @hasFilters()
      App.vent.trigger 'filterChange'

    onBeforeDestroy: ->
      @filterModel.off 'change', @updateFilter

    onDestroy: ->
      $('html').removeClass("tiny-zoom")

    checkTinyZoom: (zoom) ->
      if (zoom <= @tinySnap)
        $('html').addClass("tiny-zoom")
      else if (zoom > @tinySnap and @lastValue <= @tinySnap)
        $('html').removeClass("tiny-zoom")

    onSlide: (e,d) =>
      @checkTinyZoom(d.value)
      @lastValue = d.value

      @_getImageStyle().style.height = "#{@imageSizeBase.height * @lastValue}px"
      @_getImageStyle().style.width = "#{@imageSizeBase.width * @lastValue}px"

    onShow: ->
      @lastValue = parseInt(@_getImageStyle().style.height) / @imageSizeBase.height

      @checkTinyZoom(@lastValue)

      @$('.scalar').slider
        min: 0.5
        max: 3
        step: 0.05
        value: @lastValue
        slide: _.throttle(@onSlide, 150)

