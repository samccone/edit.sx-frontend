App.module "Collections", (Collections, App, Backbone, Marionette, $, _) ->
  class Collections.PublicEdits extends Parse.Collection
    model: App.Models.PublicEdit
    constructor: (@options) ->
    fetchRelated: ->
      (new Parse.Query(@model))
      .equalTo('edit', @options.baseEdit)
      .find()
      .then @reset.bind(this)

    _handleRealtimeUpdate: (msg) =>
      return unless msg['public-edit']?

      (new App.Models.PublicEdit(id: msg['public-edit']))
      .fetch()
      .then @add.bind(this)
      .catch (e) ->
        Raven.captureException(e)

    watchForUpdates: ->
      new Firehose.Consumer(
        uri: "#{window.FirehoseEndpoint}/#{@options.baseEdit.id}"
        message: @_handleRealtimeUpdate
        error: ->
          # TODO: Throw a sentry error here
          console?.log "** Firehose error:", arguments
        failed: ->
          # Failed is for things like a browser that supports
          # websockets but the socket connection failed (due to firewall
          # or something like that)
          console?.log "** Firehose failed:", arguments
      ).connect()
