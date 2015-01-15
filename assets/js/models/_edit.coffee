App.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  class Models.Edit extends Parse.Object
    className: 'Edit'

    initialize: ->
      @cacheModel = new Backbone.Model({
        editCount:    0
        imageCount:   0
        commentCount: 0
      })

    defaults:
      sortOrder: []

    # class level specific cache behaviors
    setCached = (key, val) ->
      @cacheModel.set(key, val)
      val

    getCached = (key) ->
      @cacheModel.get(key)

    cacheWrap = (cacheKey, query) ->
      if cache = getCached.call(@, cacheKey)
        Promise.resolve(cache)
      else
        query.call(@)
        .then (data) =>
          setCached.call(@, cacheKey, data)

    # internal generic query generator
    # for edit images
    _getImagesQuery: ->
      (new Parse.Query(App.Models.EditImage))
        .equalTo("Edit", this)

    getCommentCount: ->
      cacheWrap.call(@, "commentCount", =>
        @_getImagesQuery()
        .select("comments")
        .find()
        .then (images) =>
          images.reduce( (memo, image) ->
            if image.get("comments")?
              memo += +image.get("comments")
            else
              memo
          , 0)
        )

    getImageCount: ->
      cacheWrap.call @, "imageCount", =>
        (new Parse.Query(App.Models.EditImage))
          .equalTo("Edit", this)
          .count()

    getEditCount: ->
      cacheWrap.call @, "editCount", =>
        @getEdits().then (edits) -> edits.length

    getEdits: ->
      (new App.Collections.PublicEdits(baseEdit: this))
      .fetchRelated()

    getTileImagePreviews: ->
      cacheWrap.call(@, "previewImages", =>
        @_getImagesQuery()
        .limit(4)
        .exists('x500x500_url')
        .find()
        .then (images) => new Parse.Collection(images)
      )

    belongsToCurrentUser: ->
      Parse.User?.current()?.id is App.request("currentEdit").get("user").id

    updateSortOrder: (order) ->
      # no need to save if the same
      return if order.join("") is @get('sortOrder').join("")

      @save({sortOrder: order})
