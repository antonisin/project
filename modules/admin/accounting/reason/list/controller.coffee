@Air.module 'Admin.Reason.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/accounting/reason/list'

    initialize: ->
      collection = App.request 'admin:fine:reason:entities'
      view = @getView collection

      @listenTo App.vent, 'admin:reason:sync', =>
        collection.fetch
          success: => view.trigger 'refresh'

      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", collection, (=>
        @show view
        App.vent.trigger 'admin:item:load'
      ), (=>)

    getView: (collection) ->
      view = new List.CompositeView
        collection: collection

      @listenTo view, 'childview:click:delete', (el, model) =>
        id = model.id

        App.execute 'show:confirm', App.request('lang:get', 'fine:reason:delete:confirm', [id]), ->
          App.vent.trigger 'admin:reason:delete', model
          App.execute 'notify:success', App.request('lang:get', 'fine:reason:delete:success')

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:reason:edit', model

      @listenTo view, 'item:add', ->
        App.vent.trigger 'admin:reason:add'

      view

    App.vent.on 'admin:reason:delete', (model) ->
      model.destroy
        wait:true
        success: =>
          App.vent.trigger 'admin:reason:sync'
