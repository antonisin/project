@Air.module 'Admin.Country', (Country, App, Backbone, Marionette, $, _) ->

  class Country.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/countries': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'countries') unless region
      new Country.List.ListController region: region
      
    edit: (id) ->
      new Country.Edit.EditController
        region: App.dialog
        model: App.request 'country:entity', id: id

    add: ->
      new Country.Edit.EditController
        region: App.dialog
        model: App.request 'country:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'countries'

    App.navigate "admin/countries" 
    API.list region 

  App.addInitializer ->
    new Country.Router
      controller: API

  App.vent.on 'admin:country:edit', (id) ->
    API.edit id

  App.vent.on 'admin:country:add',->
    API.add()
