@Air.module 'Admin.Phone', (Phone, App, Backbone, Marionette, $, _) ->
  class Phone.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/phone': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'phone') unless region
      new Phone.List.ListController region: region
      
    edit: (model) ->
      new Phone.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Phone.Edit.EditController
        region: App.dialog
        model: App.request 'admin:phone:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'phone'

    App.navigate "admin/phone" 
    API.list region 

  App.addInitializer ->
    new Phone.Router
      controller: API

  App.vent.on 'admin:phone:add', ->
    API.add()

  App.vent.on 'admin:phone:edit', (model) ->
    API.edit model
