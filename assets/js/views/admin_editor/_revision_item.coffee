App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.RevisionItem extends Marionette.ItemView
    tagName: 'li'
    template: templates.revision

    events: ->
      "click .remove": @removeRevison
      "click": @toggleRevision

    toggleRevision: ->
      if @$el.hasClass 'active'
        @trigger 'removeRevision'
      else
        @trigger 'showRevision',
          revision: @model

    removeRevison: (e) ->
      e.preventDefault()
      if window.confirm(App.Messaging.removeRevision)
        if @$el.hasClass 'active'
          @trigger 'removeRevision'
        @model.destroy()
      false

    serializeData: ->
      editor: @model.get('editor') || "unknown"
