class Amoeba.Components.ComboButton
  constructor: (@$container, @options) ->
    @$button = @$container.find(@options.button)
    @bind()

  bind: ->
    @$button.on('click', @onClick)

  onClick: =>
    if @$container.hasClass(@options.offState)
      @$container.removeClass(@options.offState).addClass("#{@options.onState} cancel-hover")
      @$button.one 'mouseleave', => @$container.removeClass('cancel-hover')
      @options.onTransitionOn?()
    else
      @$container.removeClass(@options.onState).addClass(@options.offState)
      @options.onTransitionOff?()
    false
