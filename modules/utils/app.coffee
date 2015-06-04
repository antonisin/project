@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  App.vent.on 'call:client:action',(number) ->
    xhr = new XMLHttpRequest()
    curentUser = App.request 'get:current:user'
    xhr.open("PUT", Config.routePrefix + "asterisk/" + number + "/" + curentUser.id, true)
    xhr.send()
