App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Ratings extends Marionette.ItemView
    template: templates.ratings
    className: 'ratings'
    events: ->
      "click .star": 'setRating'

    setRating: (e) ->
      return if App.request("currentRevision")

      @model.toggleActive($(e.currentTarget).data('id'))

    modelEvents: ->
      "change:currentMask": @render

    templateHelpers: ->
      isActive: @model.isActive