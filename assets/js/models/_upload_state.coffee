App.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  class Models.UploadState extends Backbone.Model
    defaults:
      uploaded: 0
      uploading: 0

    percentComplete: ->
      return 1 if @get('uploading') is 0

      @get('uploaded') / @get('uploading')

    finished: ->
      @get('uploading') is @get('uploaded')

    addUploading: (num) ->
      @set('uploading', @get('uploading') + num)

    uploadComplete: ->
      @set('uploaded', @get('uploaded')+1)
      @clear() if @finished()

    clear: ->
      @set
        'uploading': 0
        'uploaded': 0
      @trigger('finished')