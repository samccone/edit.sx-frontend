App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Message extends Marionette.ItemView
    template: _.template("<p><%=message%></p>")
    className: -> @options.type
    serializeData: -> @options

    events: ->
      'click': @remove
