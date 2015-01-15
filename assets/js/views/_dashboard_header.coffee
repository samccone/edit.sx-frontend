App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.DashboardHeader extends Marionette.LayoutView
    template:   templates.dashboard_header
    className:  'header'

    behaviors:
      ViewLinks: {}
      EditCreator: {}

    templateHelpers: ->
      userId: Parse.User.current().id
