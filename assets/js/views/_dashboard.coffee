App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.Dashboard extends Marionette.LayoutView
    template: templates.dashboard

    behaviors:
      AutoRegion: {}

    regions: ->
      'editsRegion':
        selector: '.edits'
        viewClass: App.Views.Edits
        viewOptions: =>
          collection: @options.collection

      'headerRegion':
        selector: '.header-region'
        viewClass: App.Views.DashboardHeader

