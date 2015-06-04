@Air.module 'Admin.Referal.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/engine/referal/list'

    initialize: ->
      items = App.request 'admin:referal:entities'
      view = @getListView items
        
      @listenTo App.vent, 'admin:referal:sync', (model) =>
        items.fetch
          success: =>
            view.trigger 'refresh'
            @updateData items

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

        App.execute 'show:confirm', App.request('lang:get', 'referal:delete:confirm', [id]), ->
          App.vent.trigger 'admin:referal:delete', model
          App.execute 'notify:success', App.request('lang:get', 'referal:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:referal:edit', model

      @listenTo view, 'item:add',  ->
        App.vent.trigger 'admin:referal:add' , items

      view

    App.vent.on 'admin:referal:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:referal:sync'

    updateData: (items) ->
      window.data['searchEngines'] = items.toJSON()