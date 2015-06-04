@Air.module 'Admin.Client.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/clients/list'

    initialize: ->
      items = App.request 'client:entities'
      @view = @getListView items

      App.vent.trigger 'admin:item:load'
      App.execute 'when:fetched', items, (=>
        @show @view,
          loading:
            entities: [items]
        App.vent.trigger 'admin:item:load'
        ), (=>)

      @listenTo App.vent, 'admin:client:sync', (model) =>
        @view.trigger 'refresh'

    getListView: (items) ->
      view = new List.ListView
        collection: items

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'clients:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:client:delete', model
          App.execute 'notify:success', App.request('lang:get', 'clients:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:client:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:client:add'

      view

    App.vent.on 'admin:client:delete', (model) ->
      model.destroy
        success: =>
          App.vent.trigger 'admin:client:sync'
