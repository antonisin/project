@Air.module 'Monitoring.Tag', (Tag, App, Backbone, Marionette, $, _) ->

  class Tag.View extends Air.BaseItemView
    template    : 'monitoring/tag/view'
    tagName     : 'form'
    className   : 'form-horizontal'
    _modelBinder: undefined
    dialog      :
      title: 'Тег'

    events      :
      'submit form': ->
        @trigger 'click:save', @model
        false
      'click .toggleArrow': (e) -> @toggleAction e.target
      'click .toggleLabel': (e) -> @toggleAction(e.target.nextElementSibling.children)

    templateHelpers: ->
      tags: @tags.models

    initialize: (opts)->
      @tags = opts.tags

    toggleAction: (el) ->
      @$(el)
        .toggleClass('fa-angle-up fa-angle-down')
        .closest('div').nextAll('div.col-md-12:first').toggle('blind', 400, -> App.vent.trigger 'dialog:position:update:animate')
