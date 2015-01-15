App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.SignUp extends Marionette.ItemView
    className: 'auth-wrap'
    getTemplate: -> templates.signup

    ui:
      'form': 'form.signup'
      'name': '[name="username"]'
      'password': '[name="password"]'

    behaviors:
      ViewLinks: {}

    events:
      "submit @ui.form": 'signup'

    serializeData: ->
      email: window.location.search.slice(1)?.split("=")[1] || ''

    signup: (e) ->
      e.preventDefault()
      signUp = Parse.User.signUp(@ui.name.val(), @ui.password.val())

      signUp.then(->
        App.Router.navigate 'login', trigger: 1
      ).fail (e) ->
        App.messages.show new Views.Message
          type: 'error'
          message: e.message

