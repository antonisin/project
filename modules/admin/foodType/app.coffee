@Air.module 'Admin.FoodType', (FoodType, App, Backbone, Marionette, $, _) ->

  class FoodType.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/foodTypes': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'foodTypes') unless region
      new FoodType.List.ListController region: region
      
    edit: (model) ->
      new FoodType.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new FoodType.Edit.EditController
        region: App.dialog
        model: App.request 'foodType:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'foodTypes'

    App.navigate "admin/foodTypes" 
    API.list region 

  App.addInitializer ->
    new FoodType.Router
      controller: API

  App.vent.on 'admin:foodType:edit', (model) ->
    API.edit model

  App.vent.on 'admin:foodType:add',->
    API.add()
