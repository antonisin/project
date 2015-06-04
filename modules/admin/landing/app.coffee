@Air.module 'Admin.Landings', (Landings, App, Backbone, Marionette, $, _) ->

  class Landings.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/landings'     : 'list'
      'admin/landings/:id' : 'edit'
      
  API =
    list: (region) ->
      return App.execute('admin:list', 'landings') unless region
      new Landings.List.ListController region: region

    edit: (model, region) ->
      return App.execute('admin:list', 'landings') unless region
      new Landings.Edit.EditController 
        region: region
        model : model

    add: (model) ->
      new Landings.Add.AddController
        region: App.dialog
        model : model

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'landings'

    App.navigate "admin/landings" 
    API.list region 
      
  App.vent.on 'admin:landing:edit', (model, region) ->
    App.navigate "admin/landings/#{model.id}" 
    API.edit model, region

  App.vent.on 'admin:landing:add', (model) ->
    API.add model

  App.addInitializer ->
    new Landings.Router
      controller: API
