App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Login extends Marionette.ItemView
    className: 'auth-wrap'
    getTemplate: -> templates.login

    ui:
      'form': 'form.login'
      'name': '[name="username"]'
      'password': '[name="password"]'

    behaviors:
      ViewLinks: {}

    events:
      "submit @ui.form": 'loginUser'

    loginUser: (e) ->
      e.preventDefault()
      Parse.User.logIn @ui.name.val(), @ui.password.val(),
        success: -> App.Router.navigate 'dashboard', trigger: 1
        error: (m, e) =>
          App.messages.show new Views.Message
            type: 'error'
            message: e.message
