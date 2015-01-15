App.module "Models", (Models, App, Backbone, Marionette, $, _) ->
  class Models.Comment extends Parse.Object
    className: 'Comment'