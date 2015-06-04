@Air.module 'Admin.FoodType.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/foodTypes/list'

    initialize: ->
      items = App.request 'foodType:entities'
      @view = @getListView items
        
      @listenTo App.vent, 'admin:foodType:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'foodTypes:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:foodType:delete', model
          App.execute 'notify:success', App.request('lang:get', 'foodTypes:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:foodType:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:foodType:add'

      view

    App.vent.on 'admin:foodType:delete', (model) ->
      model.destroy
        wait:true
        success:=>
          App.vent.trigger 'admin:foodType:sync'
