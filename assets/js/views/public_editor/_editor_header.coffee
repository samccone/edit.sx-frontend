App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditorHeader extends Views.EditHeader
    template: templates.editor_header

    regions:
      "nameEntryRegion": '.owner-input-container'

    ui:
      "save": '.save-edit'

    initialize: ->
      @listenTo @options.publicEdit, 'change', @pendingChanges
      @listenTo @options.images, 'change', @pendingChanges

      @listenTo @options.publicEdit, 'save', -> App.execute('removeExitPrompt')

    events: ->
      "click @ui.save": @savePrompt

    getName: ->
      nameEntryView = new Views.EditorNameEntry(
        model: @options.publicEdit
        baseID: @model.id
      )

      nameEntryView.on 'nameSaved', (name) =>
        @options.publicEdit.set("editor", name)
        @_serializeAndSaveEdit()

      App.overlay.show nameEntryView

    pendingChanges: =>
      @ui.save.removeClass 'disabled'
      App.execute('exitPrompt', App.Messaging.pendingChanges)

    editSaved: =>
      @notifyPusherOfEdit()
      App.Router.navigate "editor/#{@model.id}/#{@options.publicEdit.id}"
      @ui.save.addClass 'disabled'

    _serializeAndSaveEdit: ->
      @options.publicEdit.save({
        ratings: @options.images.serializeRatings()
        colors: @options.images.serializeColors()
      }, {
        success: @editSaved
      })

    savePrompt: ->
      if @options.publicEdit.isNew()
        @getName()
      else
        @_serializeAndSaveEdit()

    notifyPusherOfEdit: (publicEditId = @options.publicEdit.id) =>
      # Client events on Pusher require authentication
      # and have other restrictions so we are proxying
      # these events through the server
      $.post("/public-edits/#{@model.id}", {id: publicEditId})
