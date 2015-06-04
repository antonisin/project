@Air.module 'Accounting.Scheme.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Base.Controller
    _name: 'scheme/list'

    initialize: ->
      collection = App.request 'scheme:entities'

      @listenTo App.vent, 'accounting:scheme:collection:add:model', (model) ->
        collection.add model

      view = @getView collection

      @show view,
        loading:
          entities: collection

    getView:(collection) ->
      view = new List.ComposedView
        collection: collection

      @listenTo view, 'childview:scheme:edit', (view, opts) ->
        App.vent.trigger 'accounting:scheme:edit', opts.model

      @listenTo view, 'childview:scheme:preview', (view, opts) ->
        App.vent.trigger 'accounting:scheme:preview', opts.model

      @listenTo view, 'childview:scheme:remove', (view, opts) ->
        @confirmDialog opts

      @listenTo view, 'scheme:add', (view) ->
        App.vent.trigger 'accounting:scheme:add'

      view

    confirmDialog: (opts) ->
      App.execute 'show:confirm', App.request('lang:get', 'scheme:delete', [opts.id]), ->
        App.execute 'notify:success', App.request('lang:get', 'userdeletesuccess')
        opts.model.destroy
          wait:true