@Air.module 'Admin.LandingDirections', (LandingDirections, App, Backbone, Marionette, $, _) ->
  class LandingDirections.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/landingDirections'     : 'list'
      
  API =
    list: (region) ->
      return App.execute('admin:list', 'landingDirections') unless region
      new LandingDirections.List.ListController region: region

    edit: (model) ->
      new LandingDirections.Edit.EditController
        region: App.dialog
        model : model

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'landingDirections'

    App.navigate "admin/landingDirections" 
    API.list region 
      
  App.vent.on 'admin:landing:directions:edit', (model, region) ->
    API.edit model

  App.addInitializer ->
    new LandingDirections.Router
      controller: API
