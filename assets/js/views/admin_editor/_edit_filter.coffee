App.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditFilter extends Marionette.ItemView
    className: 'filters'
    template: templates.ratings

    events: ->
      "click .star": @setActiveFilter

    modelEvents: ->
      "change:currentMask": @render

    setActiveFilter: (e) ->
      @model.toggleActive($(e.currentTarget).data('id'), false)

    templateHelpers: ->
      isActive: @model.isActive
