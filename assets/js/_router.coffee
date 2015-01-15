class window.Router extends Backbone.Marionette.AppRouter
  appRoutes:
    "":      "dashboard"

    "login":    "login"
    "logout":   "logout"
    "signup":   "signup"

    "dashboard": "dashboard"

    "edit/:id":     "edit"
    "editor/:id":   "editor"

    "editor/:id/:editid":       "editView"
    "editor/:id/view/:imageid": "editor"

    "settings": "userEdit"

    "*notFound": "404"

  after: ->
    _gaq?.push(['_trackPageview', Backbone.history.fragment])

  before: ->
    App.messages.currentView?.remove()
    App.overlay.currentView?.remove()
