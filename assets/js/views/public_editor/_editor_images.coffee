App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditorImages extends Views.EditImages
    childView: Views.EditImage
    getEmptyView: -> undefined

    onShow: ->
      super

      # Alert the public edit that something has changed
      @on 'sortUpdated childview:change': ->
        @sortUpdate()
        @options.publicEdit.trigger('change')

      @listenTo App.vent, 'edit:FullScreenViewerClosed', ->
        App.Router.navigate("editor/#{@options.edit.id}")

    sortUpdate: ->
      @options.publicEdit.set(
        'sortOrder',
        _.map $(".#{@getChildView()::className}"), (n) -> $(n).data('id')
      )

    fullScreenImageUpdated: (image) ->
      App.Router.navigate("editor/#{@options.edit.id}/view/#{image.id}")

    onRender: ->
      images = @collection.filter (img) -> not img.isProcessed()
      unprocessed = images.length
      if unprocessed
        new Firehose.Consumer(
          uri: "#{window.FirehoseEndpoint}/#{@options.edit.id}"
          message: (msg) =>
            if msg['new-image']
              img = @collection.get(msg['new-image'].objectId)
              img.set
                'x500x500_url': msg['new-image'].x500x500_url
                'x1800x1800_url': msg['new-image'].x1800x1800_url
          error: ->
            # TODO: Log Sentry error here
            console?.log "** Firehose error:", arguments
          failed: ->
            # Failed is for things like a browser that supports
            # websockets but the socket connection failed (due to firewall
            # or something like that)
            console?.log "** Firehose failed:", arguments
        ).connect()

    # making this method a noop for now
    # until we have a formal concept of in/out
    # the delete on a public edit should do nothing.
    deleteImages: ->

    childViewOptions: (item, index) ->
      if index is 0
        className: "#{@getChildView()::activeClassName} #{@getChildView()::className}"
      else
        className: "#{@childView::className}"
