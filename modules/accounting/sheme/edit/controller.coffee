@Air.module 'Accounting.Scheme.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Base.Controller
    _name: 'edit/edit'

    initialize: ->
      @listenTo @model, 'save:action', (array) =>
        @modelSave array

      view = @getView()

      @show view

    getView: ->
      new Edit.ItemView
        model: @model

    modelSave: (array) ->
      @model.set
        'conversions': array.conversions
        'percents'   : array.percents
        'GPLid' : array.GPLid
        'bonus' : array.bonusScheme

      @loading()
      @model.save @model.attributes,
        wait: true
        success: (model) =>
          @loading()
          @close()
          App.vent.trigger 'accounting:scheme:collection:add:model', model

