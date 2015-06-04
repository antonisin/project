@Air.module 'Admin.Consolidator.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/consolidators/list'

    initialize: ->
      items = App.request 'consolidator:entities'
      @view = @getListView items


      @listenTo App.vent, 'admin:consolidator:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'consolidators:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:consolidator:delete', model
          App.execute 'notify:success', App.request('lang:get', 'consolidators:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:consolidator:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:consolidator:add'

      view

    App.vent.on 'admin:consolidator:delete', (model) ->
      model.destroy
        success: => 
          App.vent.trigger 'admin:consolidator:sync'
