App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditTile extends Marionette.LayoutView
    tagName: 'li'
    template: templates.edit_tile
    className: 'edit-tile'

    regions:
      editImagesRegion: ".edit-images"
      editStatsRegions: ".edit-stats"

    attributes: ->
      "v-href": "edit/#{@model.id}"

    ui:
      "imageCount": ".image-count"

    onRender: ->
      @listenTo @model.cacheModel, 'change', @showStats

    onShow: ->
      @showStats()

      @model.getTileImagePreviews().then _.bind(@showImages, this)

      Promise.all([
        @model.getEditCount(),
        @model.getCommentCount(),
        @model.getImageCount()
      ]).then _.bind(@showStats, this)

    showStats: ->
      @ui.imageCount.html "(#{@model.cacheModel.get('imageCount')})"

      @editStatsRegions.show new Views.EditTileStats(
        model: @model.cacheModel
      )

    showImages: (images) ->
      @editImagesRegion.show new Views.EditTileImages(
        collection: images
      )
