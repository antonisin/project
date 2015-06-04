@Air.module 'Preference', (Preference, App, Backbone, Marionette, $, _) ->

  class Preference.Router extends App.Routers.BaseRouter
    menuItem: 'preferences'
    appRoutes:
      "preferences"   : 'preferences'

  API =
    preferences: ->
      @getController 'preferences', 'tags'

    getController: (type, menuItem) ->
      new Preference.Controller
        region: App.content
        type: type
        menuItem: menuItem

  App.addInitializer ->
    new Preference.Router
      controller: API