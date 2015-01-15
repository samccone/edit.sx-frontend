App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Progress extends Marionette.ItemView
    className: "progress",
    template: _.template("<%- active %>/ <%- total %>")

    getTotalImages: ->
      App.request('currentEdit').get('sortOrder').length

    getActiveIndex: ->
      App.request('currentEdit').get('sortOrder').indexOf(@options.image.id)

    templateHelpers: ->
      total: @getTotalImages()
      active: @getActiveIndex() + 1