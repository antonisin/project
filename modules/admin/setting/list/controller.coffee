@Air.module 'Admin.Settings.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/settings/list'

    initialize: ->
      items = App.request 'setting:entities'
      @view = @getListView items

      @listenTo App.vent, 'admin:setting:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'settings:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:setting:delete', model
          App.execute 'notify:success', App.request('lang:get', 'settings:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:setting:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:setting:add'

      view

    App.vent.on 'admin:setting:delete', (model) ->
      model.destroy
        wait:true
        success:=>
          App.vent.trigger 'admin:setting:sync'
