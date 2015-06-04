@Air.module 'Admin.Country.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/countrys/list'

    initialize: ->
      items = App.request 'country:entities'
      @view = @getListView items

      @listenTo App.vent, 'admin:country:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'countrys:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:country:delete', model
          App.execute 'notify:success', App.request('lang:get', 'countrys:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:country:edit', model.id

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:country:add'

      view

    App.vent.on 'admin:country:delete', (model) ->
      model.destroy()
      App.vent.trigger 'admin:country:sync'
