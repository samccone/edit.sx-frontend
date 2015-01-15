App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.FullScreen extends Marionette.LayoutView
    className: 'full-screen small'
    template: templates.full_screen

    ui:
      image: ".image-view"

    regions:
      "rating": '.ratings-hold'
      "commentsRegions": '.comments'
      "progressRegion": ".progress-hold"

    events: ->
      "click .background-cover": @destroy
      "click .image": @advanceImage

    behaviors:
      Closeable: {}
      Overflower: {}

    advanceImage: ->
      App.vent.trigger 'edit:advance'

    onRender: ->
      # wait half a second to load the full image
      # to save the $'s
      setTimeout =>
        return if @isDestroyed

        @loadAndShowLargeImage()
      , 500

    onShow: ->
      @rating.show new Views.Ratings(model: @options.image)
      @commentsRegions.show new Views.Comments(model: @options.image)
      @progressRegion.show new Views.Progress({image: @options.image})

    serializeData: ->
      fullImage: @options.image.get('x500x500_url')

    loadAndShowLargeImage: ->
      i = new Image()
      i.onload = =>
        return if @isDestroyed
        @ui.image.css
          "background-image": "url(#{i.src})"

        @ui.image.removeClass('small').addClass('large')

      i.src = @options.image.get('x1800x1800_url')

    onDestroy: ->
      App.vent.trigger 'edit:FullScreenViewerClosed'