@Air.module 'Admin.Team', (Team, App, Backbone, Marionette, $, _) ->

  class Team.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/teams': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'teams') unless region
      new Team.List.ListController region: region
      
    edit: (model) ->
      new Team.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new Team.Edit.EditController
        region: App.dialog
        model: App.request 'team:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'teams'

    App.navigate "admin/teams" 
    API.list region 

  App.addInitializer ->
    new Team.Router
      controller: API

  App.vent.on 'admin:team:edit', (model) ->
    API.edit model

  App.vent.on 'admin:team:add',->
    API.add()
