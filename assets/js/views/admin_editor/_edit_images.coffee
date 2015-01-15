App.module "Views", (Views, App, Backbone, Marionette, $, _) ->
  class Views.EditImages extends Marionette.CollectionView
    tagName: 'ul'
    childView: Views.EditImage
    behaviors:
      KeyEvents:
        8:  -> @deleteImages()
        39: -> App.vent.trigger('edit:advance')
        37: -> App.vent.trigger('edit:previous')
        48: (e) -> @_set(e, -1)
        49: (e) -> @_set(e, 0)
        50: (e) -> @_set(e, 1)
        51: (e) -> @_set(e, 2)
        52: (e) -> @_set(e, 3)
        53: (e) -> @_set(e, 4)

        preventDefault: [8, 39, 37]

    collectionEvents: ->
      "add": @enableDisableSortable
      "remove": @enableDisableSortable

    getEmptyView: ->
      Views.EmptyEdit unless App.request("filtered")

    addChild: (m) ->
      super if m.matchesFilter()

    sortableDisabled: ->
      @options.disabled?.sortable or @collection.length is 0

    enableDisableSortable: ->
      @$el.sortable(
        if @sortableDisabled() then "disable" else "enable"
      )

    setSortable: ->
      @$el.sortable
        disabled: @sortableDisabled()
        containment: "parent"
        stop: => @updateSortOrder()

    updateSortOrder: ->
      sortOrder = _.map $(".#{@getChildView()::className}"), (n) -> $(n).data('id')
      @collection.sortOrder = sortOrder

      @trigger 'sortUpdated'

      return if App.request('publicEdit')

      @options.edit.updateSortOrder(sortOrder)

    onShow: =>
      @listenTo App.vent, 'edit:advance', @nextImage
      @listenTo App.vent, 'filterChange', -> @collection.sort()
      @listenTo App.vent, 'edit:previous', @prevImage

      @setSortable()
      @updateFullScreenImage(true, @options.activeImage) if @options.activeImage?

    childEvents: ->
      'isActive': @_setActive
      'openFullScreen': -> @updateFullScreenImage(true)

    updateFullScreenImage: (createNew = false, id)->
      if createNew or App.overlay.currentView instanceof App.Views.FullScreen
        image = @collection.get(id || @$(".#{@getChildView()::activeClassName}").data('id'))
        _.defer =>
          @fullScreenImageUpdated?(image)

        App.overlay.show new Views.FullScreen
          image: image

    prevImage: ->
      activeClass = @getChildView()::activeClassName
      a = @$(".#{activeClass}").first()
      p = if a.prev().length then a.prev() else @$(".#{@getChildView()::className}:last")

      @$(".#{activeClass}").removeClass activeClass
      p.addClass activeClass
      @updateFullScreenImage()

    nextImage: ->
      activeClass = @getChildView()::activeClassName
      a = @$(".#{activeClass}").last()
      n = if a.next().length then a.next() else @$(".#{@getChildView()::className}:first")

      @$(".#{activeClass}").removeClass(activeClass)
      n.addClass(activeClass)
      @updateFullScreenImage()

    deleteImages: ->
      return if @options.disabled?.deletion

      models = @getActiveImages()
      return unless models.length

      if window.confirm(App.Messaging[if models.length > 1 then 'deleteImages' else 'deleteImage'])
        _.invoke(models, "destroy")

      @updateSortOrder()

    _set: (e, v) ->
      if (e.ctrlKey or e.altKey)
        @_setColor(v)
      else
        @setActiveRating(v)

    _setColor: (v) ->
      return if @options.disabled?.ratings
      _.invoke(@getActiveImages(), 'setColor', v);

    _setActiveTo: (v, e) =>
      a = @getChildView()::activeClassName
      @$(".#{a}").first().nextUntil(v.el).addClass(a)

    _setActive: (v, e) =>
      if e.shiftKey
        @_setActiveTo(v, e)
      else
        a = @getChildView()::activeClassName
        @$(".#{a}").removeClass a unless e.metaKey

    getActiveImages: ->
      @$(".#{@getChildView()::activeClassName}")
       .map((i, el) => $(el).data('id'))
       .map((i, id) => @collection.get(id))
       .toArray()

    setActiveRating: (i) =>
      return if @options.disabled?.ratings
      _.invoke(@getActiveImages(), 'setActive', i);

    childViewOptions: (childView, index) ->
      if index is 0 and @collection.length
        className: "#{@getChildView()::activeClassName} #{@getChildView()::className}"
      else
        {}
