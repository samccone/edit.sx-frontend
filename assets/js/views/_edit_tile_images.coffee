App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditTileImagesImage extends Marionette.ItemView
    className: "edit-tile-image left"
    template: _.template("")
    onShow: ->
      @$el.css
        'background-image': "url(#{@model.get('x500x500_url')})"

  class Views.EditTileImages extends Marionette.CollectionView
    tagName: "ul"
    className: -> "edit-tile-images #{if @collection.length then 'half'}"
    childView: Views.EditTileImagesImage