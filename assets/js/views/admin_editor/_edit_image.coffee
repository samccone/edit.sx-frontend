App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditImage extends Marionette.ItemView
    tagName: 'li'

    className: 'single-image'
    activeClassName: 'active'

    getTemplate: ->
      if @model.isProcessed()
        templates.edit_image
      else
        templates.edit_image_processing

    onRender: ->
      @rating = new Backbone.Marionette.Region
        el: @$('.rating-hold')

      @colorRegion = new Backbone.Marionette.Region
        el: @$('.color-hold')

      @rating.show new Views.Ratings(model: @model)
      @colorRegion.show new Views.ColorRating(model: @model)

    setCommentIndicator: ->
      if @model.get("hasComment")
        @$('.has-comments').show()
      else
        @$('.has-comments').hide()

    attributes: ->
      'data-id': @model.id

    events:
      "mousedown": 'setActive'
      "dblclick": 'doubleClicked'
      "click .has-comments": 'doubleClicked'

    doubleClicked: ->
      @trigger 'openFullScreen'

    setActive: (e) ->
      @trigger 'isActive', e

      @$el.toggleClass @activeClassName

      document.activeElement?.blur?()

    serializeData: ->
      img = @model.get('x500x500_url') ? @model.localFile
      _.extend {}, {image: img}, @model.toJSON()

    checkFiltered: ->
      @destroy() unless this.model.matchesFilter()

    modelEvents: ->
      "change": @checkFiltered
      "change:hasComment": @setCommentIndicator
      "change:x500x500_url": @render
