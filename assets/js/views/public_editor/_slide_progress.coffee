App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.SlideProgress extends Marionette.ItemView
    tagName: "ul"
    className: "slide-progress-indicator"
    getTemplate: -> templates.slide_progress
    modelEvents:
      "change": "render"

    events:
      "click .orb": (e) ->
        @model.set 'active', $(e.currentTarget).index()
