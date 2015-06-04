@Air.module 'Admin.Referal', (Referal, App, Backbone, Marionette, $, _) ->
  class Referal.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/referal': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'referal') unless region
      new Referal.List.ListController region: region
      
    edit: (model) ->
      new Referal.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Referal.Edit.EditController
        region: App.dialog
        model: App.request 'admin:referal:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'referal'

    App.navigate "admin/referal" 
    API.list region 

  App.addInitializer ->
    new Referal.Router
      controller: API

  App.vent.on 'admin:referal:add', ->
    API.add()

  App.vent.on 'admin:referal:edit', (model) ->
    API.edit model
