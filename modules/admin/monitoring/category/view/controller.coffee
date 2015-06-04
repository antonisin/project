@Air.module 'Admin.Monitoring.Category', (Category, App, Backbone, Marionette, $, _) ->
  class Category.Controller extends App.Base.Controller
    name: 'admin/monitoring/category/view'

    initialize: ->
      collection = App.request 'admin:monitoring:categories:collection'
      view = @getListView collection

      @listenTo view , 'childview:click:edit' , (view, model) ->  App.vent.trigger 'admin:monitoring:category:edit', model, @region
      @listenTo view , 'click:add', -> App.vent.trigger 'admin:monitoring:category:add', @region
      @listenTo view , 'childview:click:delete' , (view, model) ->  @modelDestroy model
      @listenTo App.vent, 'admin:monitoring:category:sync', (model) =>
        collection.fetch
          success: => view.trigger 'refresh'

      App.vent.trigger 'admin:item:load'
      App.execute "when:fetched", collection, (=>
        @show view,
          loading:
            entities: [collection]
        App.vent.trigger 'admin:item:load'
      ), (=>)

    getListView: (collection) ->
      view = new Category.ListView
        collection: collection
      view

    modelDestroy: (model) ->
      App.execute 'show:confirm', App.request('lang:get', 'monitoring:category:delete:confirm', [model.id]), ->
        model.destroy
          wait:true
          success: =>
            App.execute 'notify:success', App.request('lang:get', 'userdeletesuccess')
            App.vent.trigger 'admin:monitoring:category:sync'
