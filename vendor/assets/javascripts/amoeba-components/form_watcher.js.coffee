#= require vendor/backbone.syphon

# Rails convention for booleans
Backbone.Syphon.InputReaders.register('checkbox', ($el) ->
  if $el.prop('checked') then '1' else '0'
)

class Amoeba.Components.FormWatcher
  constructor: (@model, @$form, @options = {}) ->
    @root = @options.root ? @model.paramRoot
    @originalAttributes = @model.toJSON()
    @elements = []
    @initialize()

  initialize: ->
    @filterRegex = new RegExp(@root)
    @bind()

  bind: ->
    $(@$form[0].elements).filter( (i, element) =>
      @filterRegex.test(element.name)
    ).each( (i, element) =>
      $element = $(element)
      @set(Backbone.Syphon.serialize(@$form[0], include: [$element.attr('name')])[@root]) if $element.val()
      @elements.push $element.on('change', @updateModel)
    )

  updateModel: (e) =>
    @set(Backbone.Syphon.serialize(@$form[0], include: [$(e.target).attr('name')])[@root])

  set: (attrs) ->
    @model.set(attrs, silent: true)

  clear: ->
    @model.clear(silent: true)
    @model.set(@originalAttributes, silent: true)
    $(element).val('') for element in @elements

  submit: (options = {}) ->
    @$form.find('.error').removeClass('error')

    error = options.error
    options.error = (model, resp) =>
      errors = _.keys(JSON.parse(resp.responseText).errors)
      @$form.find("##{@root}_#{name}").addClass('error') for name in errors
      error?(model, resp)

    @model.save({}, options)
