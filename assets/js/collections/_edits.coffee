App.module "Collections", (Collections, App, Backbone, Marionette, $, _) ->
  class Collections.Edits extends Parse.Collection
    model: App.Models.Edit

    comparator: (e) -> -1 * moment(e.createdAt).unix()

    canLoadMore: ->
      new Parse.Query(App.Models.Edit)
      .equalTo("user", Parse.User.current())
      .count()
      .then (c) =>
        c > @length

    fetchEdits: (skip=0) ->
      new Parse.Query(App.Models.Edit)
      .equalTo("user", Parse.User.current())
      .limit(5)
      .skip(skip)
      .find()
      .then (edits) =>
        edits.forEach (edit) =>
          @add(edit) unless @get(edit.id)
        @trigger "fetched"