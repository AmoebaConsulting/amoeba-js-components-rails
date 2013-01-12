class Amoeba.Components.FormWatcher
  constructor: (@model, @$form, @options = {}) ->
    @root = @options.root ? @model.root
    @initialize()

  initialize: ->
    @filterRegex = new RegExp(@root + '\\[(.*)\\]')
    @bind()

  bind: ->
    $(@$form[0].elements).filter( (i, element) =>
      @filter(element.name)
    ).each( (i, element) =>
      $(element).on('blur', @updateModel)
    )

  updateModel: (e) =>
    $element = $(e.target)

    @model.set(@filter($element.attr('name')), $element.val())

  filter: (name) ->
    (@filterRegex.exec(name))?[1]
