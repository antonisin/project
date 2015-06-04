@Air.module 'Accounting.Transfer.Assign', (Assign, App, Backbone, Marionette, $, _) ->

  class Assign.Controller extends App.Base.Controller
    name: 'accounting/transfer/assign'

    initialize: (opts) ->
      { model } = opts

      view = @getView model

      @show view

    getView: (model) ->
      view = new Assign.View
        model: model

      @listenTo view, 'dialog:click:save', =>
        @save model

      view

    save: (model) ->
      if !model.validate()
        console.log model
        @loading()
        model.save model.attributes,
          wait: true,
          success: (newModel) =>
            @loading()
            App.execute 'notify:success', App.request('lang:get', 'transfer:save:success')
            App.vent.trigger 'transfer:model:added', newModel
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'transfer:save:error')