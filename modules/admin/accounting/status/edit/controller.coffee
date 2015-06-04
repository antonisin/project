@Air.module 'Admin.Status.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.Controller extends App.Base.Controller
    name: 'admin/accounting/status/edit'

    initialize: ->
      @view = @getView()
      @show @view

    getView: ->
      view = new Change.ItemView
        model: @model

      @listenTo @, 'ready:save', =>
        if @view.model.hasChanged() or @model.isNew()
          @save @model
        else if !@model.hasChanged()
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          @close()

      view

    save: (model) ->
      if !model.validate()
        @loading()
        model.save model.attributes,
          wait: true,
          success: =>
            @loading()
            App.vent.trigger 'admin:status:sync'
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')