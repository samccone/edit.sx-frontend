App.module 'Models', (Models, App, Backbone, Marionette, $, _) ->
  class Models.EditImage extends Parse.Object
    className: 'EditImage'

    defaults:
      currentMask: '00000'
      color: -1
      comments: 0

    # bit masks
    # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#Example.3A_Flags_and_bitmasks
    masks: [
      '00001',
      '00010',
      '00100',
      '01000',
      '10000'
    ]

    setColor: (color, save=true) ->
      @set 'color', color

      return if !save or App.request("publicEdit")
      @save()

    # FIXME: on EditImage delete, we also need to delete the image assets from S3
    # if they exist - POST to the sinatra app to create a job to delete the S3
    # assets for a given EditImage

    removeActive: (index, save=true) =>

      #
      #  So if we have a mask like 01111
      #  and if someone clicks on the fourth star
      #  we want to unselect all and reset back to 0
      #  this bit of logic determines this fact
      #
      #  Since we store the current mask without the leading 0's
      #  we need to normalize the mask representation. I have chose
      #  to do a length comparison.
      #
      if @get('currentMask').length is 5-@masks[index].indexOf(1)
        @set 'currentMask', '00000'
        save and @save()
      else
        @setActive.apply(this, arguments)

    #
    # We only want to trigger a change event once
    # Otherwise since we are looping over the mask
    # and changing it we get a bunch of change events
    # which can cause multiple unwanted render cycles
    #
    setActive: (index, save=true) =>
      @set('currentMask', '00000', {silent: 1})

      if index > -1
        for i in [index..0]
          @set('currentMask', (@currentMask() | @_maskFromIndex(i)).toString(2), {silent: 1})

      @trigger 'change:currentMask'
      @trigger 'change'

      return if App.request("publicEdit")
      save and @save()

    toggleActive: (index, save=true) =>
      if @isActive(index)
        @removeActive(index, save)
      else
        @setActive(index, save)

    matchesFilter: ->
      filterModel = App.request("filter")

      return true if !filterModel.hasFilters()

      if filterModel.hasColor() and @get('color') isnt filterModel.get('color')
        return false

      if (filterModel.currentMask() and @currentMask() isnt filterModel.currentMask())
        return false

      true

    isActive: (index) =>
      @hasMask(@_maskFromIndex(index))

    hasColor: ->
      @get("color") isnt -1

    hasMask: (mask) =>
      !!(@currentMask() & mask)

    hasFilters: -> @currentMask() || @hasColor()

    currentMask: => parseInt(@get('currentMask'), 2)
    _maskFromIndex: (index) => parseInt(@masks[index], 2)

    isProcessed: -> Boolean @get('x500x500_url')
