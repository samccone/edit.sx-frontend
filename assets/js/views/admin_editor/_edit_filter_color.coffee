App.module 'Views', (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditColorFilter extends Views.ColorRating
    toggleColorSetter: (e) -> @$el.toggleClass 'expanded'

    setColor: (e) ->
      @model.setColor $(e.currentTarget).data('color-id'), false
      @toggleColorSetter()
