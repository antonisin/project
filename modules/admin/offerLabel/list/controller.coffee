@Air.module 'Admin.OfferLabel.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/offerLabels/list'

    initialize: ->
      items = App.request 'offerlabels:entities'
      @view = @getListView items

      @listenTo App.vent, 'admin:offerLabel:sync', (model) =>
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
        App.execute 'show:confirm', App.request('lang:get', 'offerLabels:delete:confirm', [model.id]), ->
          App.vent.trigger 'admin:offerLabel:delete', model
          App.execute 'notify:success', App.request('lang:get', 'offerLabels:remove:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:offerLabel:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:offerLabel:add'

      view

    App.vent.on 'admin:offerLabel:delete', (model) ->
      model.destroy
        wait: true,
        success:=> App.vent.trigger 'admin:offerLabel:sync'
