App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.ColorRating extends Marionette.ItemView
    getTemplate: -> templates.color_rating
    className: "color-rating-hold"

    ui:
      "currentRating": '.current-rating'

    modelEvents:
      "change:color": 'updateColor'

    events:
      "click .set-color": "setColor"
      "click @ui.currentRating": "toggleColorSetter"
      "dblclick": "toggleColorSetter"

    toggleColorSetter: (e) ->
      e.preventDefault()
      # If we are viewing a revision you should not be able to see
      # this UI element
      return if App.request("currentRevision")

      @$el.toggleClass 'expanded'

      false

    setColor: (e) ->
      @model.setColor $(e.currentTarget).data('color-id')
      @$el.removeClass 'expanded'

    updateColor: ->
      @ui.currentRating.attr('data-color-id', @model.get('color'))
