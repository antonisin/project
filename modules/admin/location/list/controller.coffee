@Air.module 'Admin.Location.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/locations/list'

    initialize: ->
      items = App.request 'location:entities'
      @view = @getListView items

      @listenTo App.vent, 'admin:location:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'locations:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:location:delete', model
          App.execute 'notify:success', App.request('lang:get', 'locations:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:location:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:location:add'

      view

    App.vent.on 'admin:location:delete', (model) ->
      model.destroy
        wait:true
        success:=>
          App.vent.trigger 'admin:location:sync'
