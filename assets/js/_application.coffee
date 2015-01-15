window.App = new Backbone.Marionette.Application()

App.on 'start', ->
  App.addRegions
    'messages': '.messages'
    'overlay': '.overlay'

  edits = new App.Collections.Edits
  App.reqres.setHandler 'edits', -> edits
