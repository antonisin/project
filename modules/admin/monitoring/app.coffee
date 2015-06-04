@Air.module 'Admin.Monitoring', (Monitoring, App, Backbone, Marionette, $, _) ->
  class Monitoring.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/monitoring/categories': 'listCategories'

  API =
    listCategories: (region) ->
      return App.execute('admin:list', 'monitoring/categories') unless region
      new Monitoring.Category.Controller region: region

    changeCategory: (model, region) ->
      if model is null then model = App.request 'admin:monitoring:category:model'
      new Monitoring.ChangeCategory.Controller
        model : model
        region: region

    changeSubcategory: (model, categoryId) ->
      if model is null then model = App.request 'admin:monitoring:subcategory:model', categoryId
      new Monitoring.Subcategory.Controller
        model : model
        region: App.dialog

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'monitoring/categories'
    App.navigate "admin/monitoring/categories"
    API.listCategories region

  App.addInitializer ->
    new Monitoring.Router
      controller: API

  App.vent.on 'admin:monitoring:category:edit', (model, region) ->
    API.changeCategory model, region

  App.vent.on 'admin:monitoring:category:add', (region) ->
    API.changeCategory null, region

  App.vent.on 'admin:monitoring:subcategory:edit', (model) ->
    API.changeSubcategory model, null

  App.vent.on 'admin:monitoring:subcategory:add', (categoryId) ->
    API.changeSubcategory null, categoryId
