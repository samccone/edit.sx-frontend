App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Editor extends Views.Edit
    template: templates.public_edit_layout

    events: ->
      "click .help": @showHelp

    behaviors:
      "HtmlClass": {class: 'public-edit'}

    showHelp: ->
      App.overlay.show new Views.EditorHelp

    showHeader: ->
      @header.show new Views.EditorHeader(
        model: @options.edit
        images: @originalImages
        publicEdit: @options.publicEdit
      )

    showImages: ->
      @options.publicEdit.set
        'edit':      @options.edit
        'sortOrder': @options.edit.get('sortOrder')

      @options.publicEdit.images = @images

      @images.show new Views.EditorImages(
        collection: @originalImages
        edit: @options.edit
        publicEdit: @options.publicEdit
        activeImage: @options.activeImage
      )

      @showFooter()

    serializeData: ->
      id: @options.edit.id
