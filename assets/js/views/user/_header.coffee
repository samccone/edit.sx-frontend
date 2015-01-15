App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.UserHeader extends Marionette.LayoutView
    template:   templates["user/header"]
    className:  'header'
    behaviors:
      ViewLinks: {}
