App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Comments extends Marionette.LayoutView
    className: "comments-hold"
    template: templates.comments

    regions: ->
      "commentsRegion": ".comment-entry",
      "entryRegion": {
        selector: ".comments-list"
        viewClass: Views.CommentsList
        viewOptions: =>
          model: @model
          collection: new App.Collections.Comments()
      }

    onShow: ->
      # There is no need to show the comment entry
      # while you are viewing a revision
      # so we hide this UI element
      unless App.request("currentRevision")
        @getRegion("commentsRegion").show(
          new Views.CommentEntry({model: @model})
        )

    behaviors:
      BottomScroller: {
        events: "commentsUpdated"
      }
      AutoRegion: {}
