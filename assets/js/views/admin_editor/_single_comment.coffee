App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.SingleComment extends Marionette.ItemView
    tagName: "li"
    className: "single-comment"
    template: templates.single_comment

    serializeData: ->
      _.extend {}, @model.attributes,
        date: moment(@model.get('createdAt')).format('M/D/YY, h:mm a')