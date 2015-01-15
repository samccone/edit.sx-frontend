App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditHeader extends Marionette.LayoutView
    template: templates.edit_header

    ui:
      'title': 'input[name=title]'
      'shareEdit': '.share-edit'
      'delete': '.delete'
      'uploadProgress': ".upload-progress"

    events: ->
      "input @ui.title": @updateTitle
      "click .save": => @model.save()
      "click .add-image": @addImage
      "click @ui.delete": @deleteEdit
      "click @ui.shareEdit": @shareEdit

    initialize: ->
      uploadState = App.request('uploadState')
      @owned = @model.get('user')?.id is Parse.User.current()?.id
      @listenTo uploadState, 'change', @updateUploading
      @listenTo uploadState, 'finished', @hideUploading

    behaviors: {
      ViewLinks: {}
    },

    shareEdit: ->
      # pre-cache the webshot image if the owner is viewing the share edit
      $.get("/shootit/#{@model.id}")

      App.overlay.show new Views.ShareModal({
        model: @model
      })

    deleteEdit: ->
      if window.confirm(App.Messaging.deleteEdit)
        @model.destroy()
        .then =>
          App.request('edits').remove(@model)
          App.Router.navigate 'dashboard', trigger: 1
        .fail =>
          alert App.Messaging.genericError

    updateTitle: ->
      @model.set('title', @ui.title.val())

    addImage: ->
      i = new App.Models.EditImage
        caption: "bar #{Math.random()}"
        Edit: @model

      i.save
        success: (d) =>
          @options.images.add i

          # need to update the sort order on the edit model
          @model.get('sortOrder').push d.id
          @model.save()

    templateHelpers: ->
      owned: @owned

    hideUploading: ->
      @ui.uploadProgress
      .css(
        opacity: 0
        width: 0
      )

    updateUploading: ->
      @ui.uploadProgress
      .css(
        opacity: 1
        width: App.request('uploadState').percentComplete()*100 + "%"
      )