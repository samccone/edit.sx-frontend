App.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  class Models.PublicEdit extends Parse.Object
    className: 'PublicEdit'
    defaults:
      ratings: {}
      deletedImages: []
      comments: []
      colors: []

    initialize: ->
      if App.request("publicEdit")
        App.vent.on "newComment", @newComment

    newComment: (comment) =>
      @get('comments').push comment.id
      @trigger "change"

    getComments: ->
      c = @get("comments")

      #TODO remove this
      if !c or !c.length or c instanceof Parse.Collection
        return Promise.resolve(this)

      new Parse.Query(App.Models.Comment)
      .containedIn("objectId", @get('comments'))
      .find().then (d) =>
        @set('comments', new App.Collections.Comments(d))

    belongsToCurrentUser: -> false

    save: ->
      ratings = {}
      _.each(
        @images.models, (image) ->
          ratings[image.id] = image.get('currentMask')
      )

      colors = {}
      _.each(
        @images.models, (image) ->
          colors[image.id] = image.get('color')
      )

      @set 'ratings', ratings
      @set 'colors', colors

      super