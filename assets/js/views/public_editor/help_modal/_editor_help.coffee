App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditorHelp extends Marionette.CompositeView
    className: "editor-help"
    childViewContainer: 'ul'

    getTemplate: -> templates.editor_help
    getChildView: -> Views.HelpSlide

    events: ->
      "click .next": @next

    behaviors: ->
      Closeable: {}
      HtmlClass: {class: "help-modal screen"}
      KeyEvents:
        39: @next
        37: @prev

    initialize: ->
      @collection = new Backbone.Collection([{
        template: templates["help_slides/one"]
      }, {
        template: templates["help_slides/two"]
      }, {
        template: templates["help_slides/four"]
      }])

      @slideModel = new Backbone.Model({
        active: 0,
        length: @collection.length
      })

    prev: ->
      @slideModel.set(
        "active",
        if (i = @slideModel.get("active") - 1) < 0
          @collection.length - 1
        else
          i
      )

    next: ->
      @slideModel.set(
        "active",
        (@slideModel.get("active")+1) % (@collection.length)
      )

    childEvents: ->
      "focus": @focusChild

    focusChild: (c, v) ->
      @slideModel.set 'active', v.model.get("position")

    onShow: ->
      progressRegion = new Marionette.Region({
        el: @$('.process-region')
      }).show(new Views.SlideProgress({
        model: @slideModel
      }))

    addChild: (child, childView, index) ->
      child.set({
        'position': index
        'slider': @slideModel
      })

      super
