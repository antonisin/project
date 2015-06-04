@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  App.commands.setHandler 'goto', (url) ->
    location.assign Config.routePrefix + url

  App.reqres.setHandler 'settings:get', (name) ->
    _.findWhere(window.data['settings'], systemName: name).value

  App.vent.on 'settings:refresh', (collection) ->
    window.data['settings'] = collection.toJSON() 

  App.vent.on 'user:refresh', (model) ->
    window.data['user'] = model.toJSON()
    App.request "user:refresh", model

  App.commands.setHandler 'scroll:page:top', ->
  	$("body, html").animate
       scrollTop :0
       ,'500' 