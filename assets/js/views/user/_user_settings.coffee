App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.UserSettings extends Marionette.ItemView
    className: "container"
    template: templates["user/settings"]

    events:
      "submit form": "handleSubmit"

    handleSubmit: (e) ->
      e.preventDefault()

      @model.save(
        Backbone.Syphon.serialize(this),
        {patch: true}
      ).then =>
        App.Router.navigate "", {trigger: 1}

      false

    serializeData: ->
      @model.set("notifications", true) if @model.get("notifications") is undefined
      _.extend {}, @model.attributes
