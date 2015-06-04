@Air.module 'Admin.AirplaneType.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/airplaneTypes/list'

    initialize: ->
      items = App.request 'airplaneType:entities'
      @view = @getListView items
        
      @listenTo App.vent, 'admin:airplaneType:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'airplaneTypes:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:airplaneType:delete', model
          App.execute 'notify:success', App.request('lang:get', 'airplaneTypes:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:airplaneType:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:airplaneType:add'

      view

    App.vent.on 'admin:airplaneType:delete', (model) ->
      model.destroy
        success: =>
          App.vent.trigger 'admin:airplaneType:sync'