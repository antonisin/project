@Air.module 'Admin.Subscriber.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/subscribers/list'

    initialize: ->
      items = App.request 'subscriber:entities'
      @view = @getListView items


      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", items, (=> 
        @show @view,
          loading:
            entities: [items]
        App.vent.trigger 'admin:item:load'
      ), (=>)
   

      @listenTo App.vent, 'admin:subscriber:sync', (model) ->
        items.push model
        @view.trigger 'refresh'

    getListView: (items) ->
      view = new List.ListView
        collection: items

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'subscribers:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:subscriber:delete', model
          App.execute 'notify:success', App.request('lang:get', 'subscribers:remove:success')

      @listenTo view, 'childview:click:edit', (view) ->
        App.vent.trigger 'admin:subscriber:edit', view, items

      @listenTo view, 'item:add', ->
        App.vent.trigger 'admin:subscriber:add', items

      view

    App.vent.on 'admin:subscriber:delete', (model) ->
      model.destroy()
      App.vent.trigger 'admin:subscriber:sync'
