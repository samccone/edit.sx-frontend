App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Edit extends Marionette.LayoutView
    template: templates.edit_layout

    regions:
      'header': '.header'
      'images': '.images'
      'edits': '.edit-list'
      'footer': '.footer'

    behaviors:
      "HtmlClass": {class: 'admin-edit'}

    onShow: ->
      uploadState = App.request('uploadState')
      App.reqres.setHandler "currentRevision", -> false

      @listenTo App.vent,     'showRevision',     @showRevision
      @listenTo App.vent,     'removeRevision',   @removeRevision

      if uploadState?
        @listenTo uploadState,  'change:uploading', -> App.execute('exitPrompt', App.Messaging.uploadsPending)
        @listenTo uploadState,  'finished',         -> App.execute('removeExitPrompt')

      @showFooter()
      @loadImages()

    loadImages: ->
      q = new Parse.Query(App.Models.EditImage)
      q.equalTo('Edit', @options.edit)

      Parse.Promise.when([@options.edit.fetch(), q.find()]).then (edit, imgs) =>
        @originalImages = new App.Collections.EditImages(imgs, {sortOrder: edit.get("sortOrder")})
        @displayImages()

    removeRevision: ->
      App.reqres.setHandler "currentRevision", -> false

      @originalImages.revertToServerState()
      @images.show new Views.EditImages(
        collection: @originalImages
        edit: @options.edit
      )

    setRevisionImageRatings: (images, revision) ->
      _.each images, (image) ->
        if revision.get('ratings')[image.id]?
          image.set('currentMask', revision.get('ratings')[image.id])

        if revision.get('colors')?[image.id]?
          image.set('color', revision.get('colors')[image.id])

    setImageCommentIndicator: (images, revision) ->
      #TODO remove this
      revision.get("comments")?.each? (comment) ->
        images.get(comment.get("image").id).set("hasComment", 1)

    setRevisionImageInfo: (images, revision) ->
      revision.getComments().then _.partial(@setImageCommentIndicator.bind(this), images)
      @setRevisionImageRatings(images.models, revision)

    showRevision: (d) ->
      App.reqres.setHandler "currentRevision", -> d.revision

      images           = new App.Collections.EditImages(@originalImages.models)
      images.sortOrder = d.revision.get("sortOrder")
      images.sort()

      @setRevisionImageInfo(images, d.revision)

      @images.show new Views.EditImages
        collection: images
        edit: @options.edit
        disabled:
          sortable: true
          deletion: true
          ratings: true

    showFooter: ->
      @footer.show new Views.Footer

    showEdits: ->
      @options.edit.getEdits()
      .then (publicEdits) =>
        publicEdits.watchForUpdates()

        @edits.show(new Views.EditRevisions(
            collection: publicEdits
            edit: @options.edit
          )
        )

    showHeader: ->
      @header.show new Views.EditHeader(
        collection: @originalImages
        model: @options.edit
      )

    showImages: ->
      @images.show new Views.EditImages(
        collection: @originalImages
        edit: @options.edit
      )

      @setUploader()
      @showEdits()

    filterValidFiles: (files) ->
      _.filter files, (f) -> f.name.match(/.*\.(gif|jpe?g|png|bmp|ico)$/i)

    setUploader: =>
      new Firehose.Consumer(
        uri: "#{window.FirehoseEndpoint}/#{@options.edit.id}"
        message: (msg) =>
          if msg['new-image']
            img = @originalImages.get(msg['new-image'].objectId)
            img.set
              'x500x500_url': msg['new-image'].x500x500_url
              'x1800x1800_url': msg['new-image'].x1800x1800_url
        error: ->
          # TODO: Throw a sentry error here
          console?.log "** Firehose error:", arguments
        failed: ->
          # Failed is for things like a browser that supports
          # websockets but the socket connection failed (due to firewall
          # or something like that)
          console?.log "** Firehose failed:", arguments
      ).connect()

      @$el.fileupload
        url: '/upload'
        add: (e, d) =>
          return if App.request("currentRevision")

          @originalImages.addDroppedImages(d.files, @options.edit).then (image) =>
            @images.currentView.updateSortOrder()
            d.submit()

        drop: (e, d) =>
          d.files = @filterValidFiles(d.files)
          App.request('uploadState').addUploading(d.files.length)

        done: @_decrementImageUpload

        error: (xhr, status, err) =>
          Raven.captureException(err)
          @_decrementImageUpload()

        submit: (e, d) =>
          file = d.files[0]

          d.formData =
            edit_id: file.editImage.get("Edit").id
            edit_image_id: file.editImage.id

    displayImages: ->
      @showImages()
      @showHeader()

    _decrementImageUpload: -> App.request('uploadState').uploadComplete()
