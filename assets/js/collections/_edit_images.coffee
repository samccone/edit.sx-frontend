App.module "Collections", (Collections, App, Backbone, Marionette, $, _) ->
  class Collections.EditImages extends Parse.Collection
    model: App.Models.EditImage
    initialize: (arr, opts={}) ->
      @sortOrder = opts.sortOrder || []

    # If the model ID is not in the collection
    # then lets put it at the end.
    # Since -1 will go to the top of the list we
    # want the inverse of this so.. the check is needed.
    comparator: (model) ->
      r = @sortOrder.indexOf(model.id)
      if r is -1 then Infinity else r

    revertToServerState: ->
      @each (model) ->
        model.set(model._serverData)

    serializeRatings: ->
      obj = {}
      @each (model) ->
        obj[model.id] = model.get("currentMask")
      obj

    serializeColors: ->
      obj = {}
      @each (model) ->
        obj[model.id] = model.get("color")
      obj

    addDroppedImages: (files, edit) ->
      uploadedImages = []

      _.each files, (f) =>
        image = new App.Models.EditImage
        f.editImage = image
        @_addLocalFile(image, f)
        uploadedImages.push image.save(Edit: edit)

      Parse.Promise.when(uploadedImages).then (images) =>
        @add(images)
        images

    _addLocalFile: (image, f) ->
      # FIXME: What do we do for the user when they dont have a browser
      # that supports FileReader???
      return unless FileReader?

      reader = new FileReader()
      reader?.onload = (f) -> image.localFile = f.currentTarget.result
      reader?.readAsDataURL(f)

