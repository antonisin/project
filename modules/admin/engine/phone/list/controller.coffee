@Air.module 'Admin.Phone.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/engine/phone/list'

    initialize: ->
      items = App.request 'admin:phone:entities'
      view = @getListView items
        
      @listenTo App.vent, 'admin:phone:sync', (model) =>
        items.fetch
          success: => view.trigger 'refresh'

      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", items, (=> 
        @show view
        App.vent.trigger 'admin:item:load'
      ), (=>)

    getListView: (items) ->
      view = new List.ListView
        collection: items

      @listenTo view, 'childview:click:delete', (el, model) =>
        id = model.id

        App.execute 'show:confirm', App.request('lang:get', 'phone:delete:confirm', [id]), ->
          App.vent.trigger 'admin:phone:delete', model
          App.execute 'notify:success', App.request('lang:get', 'phone:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:phone:edit', model

      @listenTo view, 'item:add',  ->
        App.vent.trigger 'admin:phone:add' , items

      view

    App.vent.on 'admin:phone:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:phone:sync'
