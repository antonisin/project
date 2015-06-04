@Air.module 'Admin.Monitoring.ChangeCategory', (ChangeCategory, App, Backbone, Marionette, $, _) ->
  class ChangeCategory.Controller extends App.Base.Controller
    name: 'admin/monitoring/category/change'

    initialize: ->
      @layout       = @getLayout()
      @subcategories = App.request 'admin:monitoring:subcategories:collection', @model.id

      @listenTo @layout, 'show' ,=>
        @showCategory()
        @showSubcategories @subcategories

      @show @layout,
        loading:
          type: 'opacity'
          entities: [@subcategories, @model]

    showCategory: ->
      view = new ChangeCategory.CategoryItemView
        model: @model
      @layout.category.show view
      @listenTo view, 'model:save', (model) -> @modelSave model
      view

    showSubcategories: (collection) ->
      view = new ChangeCategory.SubategoryListView
        collection: collection

      @layout.subcategories.show view

      @listenTo @, 'enable:button', => view.trigger 'enable:add:button'
      @listenTo view, 'click:add', -> App.vent.trigger 'admin:monitoring:subcategory:add', @model.id
      @listenTo view, 'childview:model:edit', (view, model) -> App.vent.trigger 'admin:monitoring:subcategory:edit', model
      @listenTo view, 'childview:click:delete', (view, model) ->  @modelDestroy model

      @listenTo App.vent, 'admin:monitoring:subcategory:sync', =>
        collection.url = Config.routePrefix + 'monitoring/subcategories/' + @model.id
        collection.fetch
          success: => view.trigger 'refresh'

      view

    getLayout: ->
      new ChangeCategory.LayoutCategory

    modelSave: (model) ->
      if !model.validate()
        model.save model.attributes,
          wait: true,
          success: (@subcategories) =>
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            App.vent.trigger 'admin:monitoring:category:sync'
            @trigger 'enable:button'
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')

    modelDestroy: (model) ->
      App.execute 'show:confirm', App.request('lang:get', 'monitoring:subcategory:delete:confirm', [model.id]), ->
        model.destroy
          wait:true
          success: =>
            App.execute 'notify:success', App.request('lang:get', 'userdeletesuccess')
            App.vent.trigger 'admin:monitoring:category:sync'
