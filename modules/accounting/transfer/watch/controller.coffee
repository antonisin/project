@Air.module 'Accounting.Transfer.Watch', (Watch, App, Backbone, Marionette, $, _) ->

  class Watch.Controller extends App.Base.Controller
    initialize: ->
      @model = App.request 'watcher:entity'
      view = @getView()

      @show view

    getView: ->
      view = new Watch.View
        model: @model

      @listenTo view, 'dialog:click:save', =>
        @save()

      view

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait: true,
          success: =>
            @loading()
            @close()
            App.execute 'notify:success', App.request('lang:get', 'watcher:save:success')
      else
        App.execute 'notify:error', App.request('lang:get', 'watcher:save:error')