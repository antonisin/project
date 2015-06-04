@Air.module 'Admin.CityCode.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/engine/cityCode/list'

    initialize: ->
      items = App.request 'admin:cityCode:entities'
      view = @getListView items

      @listenTo App.vent, 'admin:cityCode:sync', (model) =>
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

        App.execute 'show:confirm', App.request('lang:get', 'cityCode:delete:confirm', [id]), ->
          App.vent.trigger 'admin:cityCode:delete', model
          App.execute 'notify:success', App.request('lang:get', 'cityCode:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:cityCode:edit', model

      @listenTo view, 'item:add',  ->
        App.vent.trigger 'admin:cityCode:add' , items

      view

    App.vent.on 'admin:cityCode:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:cityCode:sync'

    updateData: (items) ->
      window.data['cityCodes'] = items.toJSON()