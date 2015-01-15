@App.module 'Messaging', (Messaging, App, Backbone, Marionette, $, _) ->
  _.extend Messaging,
    uploadsPending: "Images Are Still Uploading, Leaving this page will result in lost data"
    removeRevision: "Are you sure you want to remove this revision?"
    pendingChanges: "Any changes you have made will not be saved!"
    emptyComment: "Please leave a comment!"
    genericError: "Looks like something went wrong, please try again"
    deleteEdit: "Are you sure you want to delete this edit?"
    deleteImage: "Permanently Delete this image?"
    deleteImages: "Permanently Delete these images?"

  App.on 'start', ->
    App.commands.setHandler 'exitPrompt', (message) ->

      window.onbeforeunload = (e) ->
        e ||= window.event

        # For IE6-8 and Firefox prior to version 4
        e.returnValue = message if e

        # For Chrome, Safari, IE8+ and Opera 12+
        message

    App.commands.setHandler 'removeExitPrompt', ->
      window.onbeforeunload = null
