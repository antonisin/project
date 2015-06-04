@Air.module 'Utils.Roles', (Roles, App, Backbone, Marionette, $, _) ->

  API = 

    filter: (arr) ->
      role = App.request('get:current:user').get 'role'
      
      _.filter arr, (el) ->
        el if el.role.length is 0 or el.role.indexOf(role) isnt -1

  App.reqres.setHandler 'role:filter', API.filter