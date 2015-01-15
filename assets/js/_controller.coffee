class window.Controller extends Marionette.Controller
  userEdit: ->
    return if authRedirect()
    App.AppRegion.show(new App.Views.UserEdit)

  login: ->
    App.AppRegion.show(new App.Views.Login) unless isAuthRedirect()

  logout: ->
    Parse.User.logOut()
    App.Router.navigate '', trigger: 1

  signup: ->
    App.AppRegion.show(new App.Views.SignUp) unless isAuthRedirect()

  dashboard: ->
    return if authRedirect()

    edits = App.request('edits')

    App.AppRegion.show new App.Views.Dashboard(
      collection: edits
    )

    edits.fetchEdits()

  editor: (id, activeImage) ->
    App.reqres.setHandler 'publicEdit', -> true
    App.reqres.setHandler 'currentEdit', -> publicEdit

    edit = new App.Models.Edit
      id: id

    publicEdit = new App.Models.PublicEdit

    edit.fetch()
    .then (d) ->
      App.AppRegion.show new App.Views.Editor
        edit: edit
        publicEdit: publicEdit
        activeImage: activeImage
    .fail ->
      # redirect if we do not have
      # the edit that they are looking for
      App.Router.navigate '', trigger: 1

  # redirect to the main edit page
  editView: (id, editId) ->
    App.Router.navigate "editor/#{id}", trigger: 1

  edit: (id) ->
    App.reqres.setHandler 'uploadState', -> uploadState
    App.reqres.setHandler 'currentEdit', -> edit

    edit = new App.Models.Edit
      id: id

    uploadState = new App.Models.UploadState

    edit.fetch()
    .then (d) ->
      if edit.get('user').id is Parse.User.current()?.id
        App.AppRegion.show new App.Views.Edit
          edit: edit
      else
        App.Router.navigate "editor/#{id}", trigger: 1

    .fail ->
      App.Router.navigate '', trigger: 1

  404: ->
    unless isAuthRedirect()
      window.location.pathname = "/"

  isAuthRedirect = ->
    if Parse.User.current()
      App.Router.navigate 'dashboard', trigger: 1
      return true
    false

  authRedirect = ->
    unless Parse.User.current()
      App.Router.navigate 'login', trigger: 1
      return true
    false
