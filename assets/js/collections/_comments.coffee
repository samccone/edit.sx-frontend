App.module "Collections", (Collections, App, Backbone, Marionette, $, _) ->
  class Collections.Comments extends Parse.Collection
    model: App.Models.Comment

    fetchAdminComments: (image) ->
      (new Parse.Query(@model))
      .equalTo("image", image)
      .equalTo("adminComment", true)
      .find()

    fetchEditComments: (image) ->
      return Promise.resolve([]) unless edit = App.request('currentRevision')

      edit.get("comments").filter (comment) -> comment.get("image").id is image.id

    fetchComments: (image) ->
      Promise.all([@fetchAdminComments(image), @fetchEditComments(image)])
      .then((d) => @reset(_.flatten(d)))
      .catch((e) -> console.log e)
