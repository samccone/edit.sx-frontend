App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EmptyEditsView extends Marionette.ItemView
    tagName: 'li'
    className: 'empty edit-tile create-edit'
    template: templates.empty_edits
    behaviors:
      EditCreator: {}