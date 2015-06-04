@Air.module 'Preference.Tags', (Tags, App, Backbone, Marionette, $, _) ->

  class Tags.Controller extends App.Base.Controller
    initialize: ->
      @collection = App.request 'preference:tags:collection', @model.id

      @listenTo App.vent, 'preference:tags:add:model', (model) =>
        @collection.push model
        @collection.reset @collection.models

      view = @getView()

      @show view,
        loading:
          entities: @collection

    getView: ->
      view = new Tags.CompositeView
        collection: @collection

      @listenTo view, 'childview:preference:tag:delete',(view, object) =>
        App.execute 'show:confirm', App.request('lang:get', 'task:tag:delete:confirmation', [object.model.id]), ->
          object.model.destroy
            wait:true
            success: =>
              App.execute 'notify:success', App.request('lang:get', 'task:tag:delete:success')

      @listenTo view, 'childview:preference:tag:edit', (view, object) =>
        App.vent.trigger 'preference:tag:model:edit', object.model

      @listenTo view, 'preference:tags:add', =>
        App.vent.trigger 'preference:tag:model:add'

      view