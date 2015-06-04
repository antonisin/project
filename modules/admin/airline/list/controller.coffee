@Air.module 'Admin.Airline.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/airlines/list'

    initialize: ->
      items = App.request 'airline:entities'
      @view = @getListView items
      
      @listenTo App.vent, 'admin:airline:sync', (model) =>
        items.fetch
          success: => @view.trigger 'refresh'

      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", items, (=> 
        @show @view
        App.vent.trigger 'admin:item:load'
      ), (=>)
      
    getListView: (items) ->
      view = new List.ListView
        collection: items

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'airlines:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:airline:delete', model
          App.execute 'notify:success', App.request('lang:get', 'airlines:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:airline:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:airline:add'

      view

    App.vent.on 'admin:airline:delete', (model) ->
      model.destroy()
      App.vent.trigger 'admin:airline:sync'
