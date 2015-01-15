App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.ShareModal extends Marionette.ItemView
    template: templates.social_share

    className: "social-modal"

    behaviors:
      Closeable: {}
      Overflower: {}

    serializeData: ->
      url = "#{window.location.origin}/editor/#{@model.id}"

      url: url
      encoded: encodeURIComponent(url)
