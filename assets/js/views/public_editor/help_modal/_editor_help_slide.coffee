App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.HelpSlide extends Marionette.ItemView
    tagName: "li"
    className: "help-slide"
    getTemplate: -> this.model.get('template')
    triggers:
      "click": "focus"

    initialize: ->
      @listenTo @model.get("slider"), "change:active", @updateActive

    updateActive: ->
      @$el.attr 'class', @className + @getSlideClass()

    getSlideClass: ->
      activeSlide = @model.get("slider").get("active")
      slideCount  = @model.get("slider").get("length") - 1

      offset = @model.get("position") - activeSlide

      # when at the start
      if (activeSlide is 0 and @model.get("position") is slideCount)
        return " prev"

      # when at the end
      if (activeSlide is slideCount and @model.get("position") is 0)
        return " next"

      if (offset is 0)
        return " active"
      if (offset is 1)
        return " next"
      if (offset is -1)
        return " prev"

      ""

    onShow: ->
      @$el.attr 'class', @className + @getSlideClass()
