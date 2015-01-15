App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.RevisionList extends Marionette.CollectionView
    tagName: 'ul'
    childView: Views.RevisionItem
    emptyView:  Views.RevisionListEmpty

    childEvents:
      "showRevision": (v, d) ->
        @$('.active').removeClass 'active'
        v.$el.addClass 'active'
        App.vent.trigger 'showRevision', d

      "removeRevision": (v, d) ->
        @$('.active').removeClass 'active'
        App.vent.trigger 'removeRevision'

    childViewOptions: (v, i) ->
      edit: @options.edit
      className: -> if i % 2 then 'odd'
