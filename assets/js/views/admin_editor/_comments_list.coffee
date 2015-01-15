App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.CommentsList extends Marionette.CollectionView
    tagName: "ul"
    getChildView: -> Views.SingleComment

    onShow: ->
      @listenTo App.vent, "newComment", (d) =>
        @collection.add(d)

      @collection.fetchComments(@options.model)

    onAddChild: ->
      App.vent.trigger "commentsUpdated"

    onRender: ->
      App.vent.trigger "commentsUpdated"
