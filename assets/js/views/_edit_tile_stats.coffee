App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditTileStats extends Marionette.ItemView
    template: templates.edit_tile_stats

    serializeData: ->
      _.extend {}, @model.attributes, {
        editCopy: if +@model.get("editCount") is 1 then "edit" else "edits"
      }