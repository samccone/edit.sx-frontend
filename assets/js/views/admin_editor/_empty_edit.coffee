App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EmptyEdit extends Marionette.ItemView
    className: 'empty-uploads'
    template: templates.empty_uploads
