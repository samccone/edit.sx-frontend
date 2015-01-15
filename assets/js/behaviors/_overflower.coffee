App.module "Behaviors", (Behaviors, App, Backbone, Marionette, $, _) ->
  class Behaviors.Overflower extends Marionette.Behavior
    onShow: ->
      $('html').css 'overflow': 'hidden'

    onDestroy: ->
      $('html').css 'overflow': 'auto'
