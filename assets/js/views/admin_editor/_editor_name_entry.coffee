App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditorNameEntry extends Marionette.ItemView
    template: templates.editor_name_entry
    ui:
      "saveEditor": '.btn.save'
      "editor": '.editor-name'

    events: ->
      "click @ui.saveEditor": @saveWithEditor
      "keydown @ui.editor": @checkEnterSubmit
      "input @ui.editor": @updateEditorSave

    behaviors:
      Overflower: {}
      HtmlClass: {class: "screen"}
      Closeable: {}

    updateEditorSave: ->
      if @ui.editor.val().length
        @ui.saveEditor.removeClass 'disabled'
      else
        @ui.saveEditor.addClass 'disabled'

    saveWithEditor: ->
      @trigger 'nameSaved', @ui.editor.val()
      @destroy()

    checkEnterSubmit: (e) ->
      @saveWithEditor() if e.keyCode is 13

    serializeData: ->
      title: @model.get("edit").get("title")