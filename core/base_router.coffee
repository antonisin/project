@Air.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.BaseRouter extends Marionette.AppRouter

    before: ->
      App.vent.trigger 'menu:choose', @menuItem

      role = App.request('get:current:user').get 'role'
      if @role and @role.length isnt 0 and @role.indexOf(role) is -1
        App.execute 'show:error', App.request('lang:get', 'role:no:access')

