@Air.module 'Admin.Team.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ListController extends App.Base.Controller
    name: 'admin/teams/list'

    initialize: ->
      @collection = App.request 'team:entities'
      @view = @getListView()

      @listenTo App.vent, 'admin:team:added', (model) =>
        @collection.add model

      @listenTo App.vent, 'admin:team:removed', (model) =>
        @collection.remove model

      App.vent.trigger 'admin:show:title'

      @show @view,
        loading:
          entities: [@collection]

    getListView: ->
      view = new List.ListView
        collection: @collection

      @listenTo view, 'childview:click:delete', (el, model) =>
        App.execute 'show:confirm', App.request('lang:get', 'team:delete:confirm', [model.id]), =>
          @delete model

      @listenTo view, 'childview:click:edit', (el, model) =>
        App.vent.trigger 'admin:team:edit', model

      @listenTo view, 'item:add', =>
        App.vent.trigger 'admin:team:add'

      view

    delete: (model) ->
      model.destroy
        success: (oldModel) =>
          App.vent.trigger 'admin:team:removed', oldModel
          App.execute 'notify:success', App.request('lang:get', 'team:remove:success')