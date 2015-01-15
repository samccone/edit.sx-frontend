App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.UserEdit extends Marionette.LayoutView
    template: templates['user/edit']

    behaviors:
      AutoRegion: {}

    regions: ->
      "headerRegion":
        selector: ".header-region"
        viewClass: App.Views.UserHeader
      "settingsRegions":
        selector: '.user-settings'
        viewClass: App.Views.UserSettings
        viewOptions:
          model: Parse.User.current()
