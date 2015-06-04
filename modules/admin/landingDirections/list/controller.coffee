@Air.module 'Admin.LandingDirections.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/landingDirections/list'

    initialize: ->
      @collection = App.request 'landing:directions:entitie'
      @view       = @getView @collection 

      @listenTo App.vent, 'admin:landing:directions:sync', (model) =>
        @collection.fetch
          success: =>
            @view.trigger 'refresh'
            @updateData()
        
      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", @collection, (=> 
        @show @view
        App.vent.trigger 'admin:item:load'
      ), (=>)
    
    getView: ->
      view = new List.ListView
        collection: @collection

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:landing:directions:edit', model, @region

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'landing:direction:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:landing:direction:delete', model

      @listenTo view, 'item:add', =>
        model = App.request 'landing:direction:new:entity'
        model.validation.image.required = true
        App.vent.trigger 'admin:landing:directions:edit', model 
        
      view   

    App.vent.on 'admin:landing:direction:delete', (model) ->
      if model.id 
        model.destroy
          success: => 
            App.execute 'notify:success', App.request('lang:get', 'landing:direction:delete:success')  
            App.vent.trigger 'admin:landing:directions:sync'  
        
    updateData: ->
      window.data['landingdirections'] = @collection.toJSON()