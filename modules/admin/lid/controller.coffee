@Air.module 'Admin.Lids', (Lids, App, Backbone, Marionette, $, _) ->

  class Lids.ListController extends App.Base.Controller
    name: 'admin/lids'

    initialize: ->
      items = App.request 'admin:lid:entities'
      @view = @getListView items

      @listenTo App.vent, 'admin:lid:sync', (model) =>
        items.fetch
          success: => @view.trigger 'refresh'
      
      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", items, (=> 
        @show @view
        App.vent.trigger 'admin:item:load'
      ), (=>)

    getListView: (items) ->
      view = new Lids.ListView
        collection: items

      @listenTo view, 'childview:click:delete', (el, model) =>
        id = model.id

        App.execute 'show:confirm', App.request('lang:get', 'lid:delete:confirm', [id]), ->
          App.vent.trigger 'admin:lid:delete', model
        
      @listenTo view, 'childview:item:click', (el, model) =>
        App.execute 'goto', "#lid/#{model.id}"

      view

    App.vent.on 'admin:lid:delete', (model) ->
      model.destroy
        success :=>
          App.execute 'notify:success', App.request('lang:get', 'lid:delete:success')
      App.vent.trigger 'admin:lid:sync'
