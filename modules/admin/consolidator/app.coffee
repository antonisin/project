@Air.module 'Admin.Consolidator', (Consolidator, App, Backbone, Marionette, $, _) ->

  class Consolidator.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/consolidators': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'consolidators') unless region
      new Consolidator.List.ListController region: region
      
    edit: (model) ->
      new Consolidator.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Consolidator.Edit.EditController
        region: App.dialog
        model: App.request 'consolidator:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'consolidators'

    App.navigate "admin/consolidators" 
    API.list region 

  App.addInitializer ->
    new Consolidator.Router
      controller: API

  App.vent.on 'admin:consolidator:edit', (model) ->
    API.edit model

  App.vent.on 'admin:consolidator:add',->
    API.add()
