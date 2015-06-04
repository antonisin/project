@Air.module 'Lid.ChangeTask', (ChangeTask, App, Backbone, Marionette, $, _) ->

  class ChangeTask.Controller extends App.Base.Controller

    initialize: ->
      @show @getView()

    getView: ->
      view = new ChangeTask.ItemView
        model: @model

      @listenTo view, 'dialog:click:save', =>
       if @model.hasChanged() or @model.isNew()
         @save()
       else
         App.execute 'notify:info', App.request('lang:get', 'nothing:changed' )
         @close()

      view

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait: true,
          success: (model) =>
            @loading()
            App.vent.trigger 'task:paper:add:model', model
            App.execute 'notify:success', App.request('lang:get', 'task:save:success')
            @close()
      else
       App.execute 'notify:error', App.request('lang:get', 'task:save:error')