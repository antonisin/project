@Air.module 'Admin.Status.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/accounting/status/list'

    initialize: ->
      collection = App.request 'admin:fine:status:entities'
      view = @getView collection

      @listenTo App.vent, 'admin:status:sync', =>
        collection.fetch
          success: => view.trigger 'refresh'

      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", collection, (=>
        @show view
        App.vent.trigger 'admin:item:load'
      ), (=>)

    getView: (collection) ->
      view = new List.CompositeView
        collection: collection

      @listenTo view, 'childview:click:delete', (el, model) =>
        id = model.id

        App.execute 'show:confirm', App.request('lang:get', 'fine:status:delete:confirm', [id]), ->
          App.vent.trigger 'admin:status:delete', model
          App.execute 'notify:success', App.request('lang:get', 'fine:status:delete:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:status:edit', model

      @listenTo view, 'item:add', ->
        App.vent.trigger 'admin:status:add'

      view

    App.vent.on 'admin:status:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:status:sync'
