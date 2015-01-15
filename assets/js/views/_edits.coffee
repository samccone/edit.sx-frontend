App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
    class Views.Edits extends Marionette.CompositeView
      template: templates["dashboard/edit_list"]
      childView: Views.EditTile
      childViewContainer: ".edits"
      getEmptyView: -> Views.EmptyEditsView

      behaviors:
        "ViewLinks": {}

      ui:
        "loadMore": ".load-more"

      events:
        "click @ui.loadMore": "loadMore"

      collectionEvents: ->
        "fetched": ->
          @collection.canLoadMore()
          .then (canLoadMore) =>
            @ui.loadMore[if canLoadMore then "show" else "hide"]()
            .css("opacity": 1)

      loadMore: ->
        @collection.fetchEdits(@collection.length)