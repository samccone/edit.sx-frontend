App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.CommentEntry extends Marionette.ItemView
    className: 'inner'
    template: templates.comment_entry
    ui:
      commentField: ".comment-field"

    events:
      "click .submit": "onSubmit"
      "keydown .comment-field": (e) -> @onSubmit() if e.keyCode is 13

    onSubmit: ->
      if (comment = $.trim(@ui.commentField.val())).length
        @createComment(comment)
      else
        alert App.Messaging.emptyComment

    createComment: (text) ->
      comment = new App.Models.Comment
        text:         text
        image:        @model
        adminComment: App.request("currentEdit").belongsToCurrentUser()

      comment.save().then (d) =>
        App.vent.trigger "newComment", d

        @model.increment('comments').save()
        @render()