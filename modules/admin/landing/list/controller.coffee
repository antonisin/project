@Air.module 'Admin.Landings.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/landing/list'

    initialize: ->
      @collection = App.request 'landing:entitie'
      @view       = @getView @collection

      @listenTo App.vent, 'admin:landing:sync', (model) =>
        @collection.fetch
          success: => @view.trigger 'refresh'

      App.vent.trigger 'admin:item:load'

      App.vent.on 'admin:landings:push:model', (model) ->
        @trigger 'push:landing:model', model
        @collection.push model
      
      App.execute "when:fetched", @collection, (=> 
        @show @view
        App.vent.trigger 'admin:item:load'
      ), (=>)
    
    getView: ->
      view = new List.ListView
        collection: @collection

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:landing:edit', model, @region

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'landing:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:landing:delete', model
          App.execute 'notify:success', App.request('lang:get', 'landing:direction:delete:success')
      @listenTo view, 'item:add', =>
        model = App.request 'landing:new:entity'
        App.vent.trigger 'admin:landing:add', model 

      view   

    App.vent.on 'admin:landing:delete', (model) ->
      if model.id 
         model.destroy
          success: => App.vent.trigger 'admin:landing:sync'   
      else 
        model.trigger 'destroy', model, model.collection 
        App.vent.trigger 'admin:landing:sync'   

        