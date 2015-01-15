App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditRevisions extends Marionette.LayoutView
    template: templates.edit_revisions

    ui:
      title: '.title'

    regions:
      'revisions': '.revision-list'

    events: ->
      'blur @ui.title': @updateTitle
      "click .toggle-collapse": @toggleCollapse

    toggleCollapse: (e) ->
      $html = $('html')
      $html.toggleClass 'hidden-edit-list'

      if $html.hasClass('hidden-edit-list')
        e.stopImmediatePropagation()

        @$el.parent().one "click", (e) =>
          @toggleCollapse(e)
          false

    updateTitle: ->
      @options.edit.save
        title: @ui.title.val()

    serializeData: ->
      @options.edit.toJSON()

    onShow: ->
      @revisions.show new Views.RevisionList
        collection: @options.collection
        edit: @options.edit

    onDestroy: ->
      $('html').removeClass('hidden-edit-list')