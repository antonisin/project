@Air.module 'Admin.OfferComment.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/offerComments/list'

    initialize: ->
      items = App.request 'offercomments:entities'
      @view = @getListView items
        
      @listenTo App.vent, 'admin:offerComment:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'offerComments:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:offerComment:delete', model
          App.execute 'notify:success', App.request('lang:get', 'offerComments:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:offerComment:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:offerComment:add'

      view

    App.vent.on 'admin:offerComment:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:offerComment:sync'
