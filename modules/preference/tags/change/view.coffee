@Air.module 'Preference.Tags.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.ItemView extends App.BaseItemView
    template: 'preference/tag/change/change'
    className: 'row'
    events:
      'click i' : 'setIcon'
    dialog: ->
      title:  'Title'

    onShow: ->
      @bind()

    bind: ->
      @bindings =
        name: '[name="name"]'
        inList: '[name="inList"]'
        showCounter: '[name="showCounter"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    setIcon: (e) ->
      @$el.find('i').removeClass('active')
      @$el.find(e.target).addClass('active')
      @trigger 'change:tag:icon', e.target.classList[1]
