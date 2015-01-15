App.module "Behaviors", (Behaviors, App, Backbone, Marionette, $, _) ->
  class Behaviors.EditCreator extends Marionette.Behavior
    ui:
      "createEdit": ".create-edit"

    events:
      "click @ui.createEdit": "createEdit"

    createEdit: ->
      e = new App.Models.Edit
        title: "Edit - #{moment().format('MMMM Do, h:mm:ss');}"
        user: Parse.User.current()

      e.save
        success: (d) =>
          App.Router.navigate "edit/#{d.id}",  trigger: 1
          App.request('edits').add e, silent: true