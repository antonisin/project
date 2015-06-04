@Air.module 'Admin.Users.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListController extends App.Base.Controller
    name: 'admin/users/list'

    initialize: ->
      items = App.request 'admin:user:entities'
      @view = @getListView items
        
      @listenTo App.vent, 'admin:user:sync', (model) =>
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
        id = model.id

        App.execute 'show:confirm', App.request('lang:get', 'user:delete:confirm', [id]), ->
          App.vent.trigger 'admin:user:delete', model
          App.execute 'notify:success', App.request('lang:get', 'user:remove:success')

      @listenTo view, 'childview:click:view', (el, model) =>
        App.execute 'goto', "#profile/#{model.id}"

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:user:edit', model

      @listenTo view, 'item:add',  ->
        App.vent.trigger 'admin:user:add' , items

      @listenTo view, 'childview:statistic:model:update' ,(view, model, priority, userLimit) ->
        model.set 'priority': priority, 'userLimit': userLimit
        model.save model.attributes,
          wait: true,
          success: =>
           App.execute 'notify:success' , App.request('lang:get', 'data:save:success')

      view

    App.vent.on 'admin:user:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:user:sync'
