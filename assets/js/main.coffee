#=require _application
#=require _router
#=require _controller
#=require _messaging
#=require models/_edit_image
#=require_tree views
#=require_tree models
#=require_tree collections
#=require_tree behaviors

App.on 'start', ->
  App.addRegions
    'AppRegion': '#app'

  App.Router = new Router(controller: new Controller)
  Backbone.history.start(pushState: true)

$ -> App.start()
