@Air.module 'Accounting.Transfer.New', (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Base.Controller
    initialize: ->
      @model = App.request 'transfer:entity'
      @view = @getView()

      @listenTo @view, 'transfer:save', =>
        @save @model

      @listenTo @view, 'new:transfer:close', => @close()

      @show @view

    getView: (model) ->
      new New.View
        model: @model

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait: true,
          success: (model) =>
            @loading()
            App.execute 'notify:success', App.request('lang:get', 'transfer:save:success')
            App.vent.trigger 'transfer:model:added', model
            @view.trigger 'new:transfer:close'
            App.request 'transfer:new', @region
      else
        App.execute 'notify:error', App.request('lang:get', 'transfer:save:error')