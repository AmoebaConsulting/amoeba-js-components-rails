class Amoeba.Components.ComboButton
  constructor: (@$container, @options) ->
    if @$container.length == 1
      @on = if @$container.hasClass(@options.offState) then false else true
      @$button = @$container.find(@options.button)
      @bind()
    else
      @$container.each (i, container) =>
        new @constructor($(container), @options)

  bind: ->
    @$button.on('click', @onClick)

  onClick: =>
    if @on
      @options.onTransitionOff?()
    else
      @$container.addClass('cancel-hover')
      @$button.one 'mouseleave', => @$container.removeClass('cancel-hover')
      @options.onTransitionOn?()
    @toggle()
    false

  toggle: =>
    if @on
      @$container.removeClass(@options.onState).addClass(@options.offState)
    else
      @$container.removeClass(@options.offState).addClass(@options.onState)
    @on = not @on
