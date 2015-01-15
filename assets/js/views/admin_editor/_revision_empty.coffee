App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.RevisionListEmpty extends Marionette.ItemView
    tagName: 'li'
    template: templates.empty_revision