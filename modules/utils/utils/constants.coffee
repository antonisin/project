@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  Constants = 
    datePickerFormat: 'dd/mm/yyyy'
    dateFormat: 'D MMM YYYY'

  App.reqres.setHandler 'constants:get', (name) =>
    Constants[name] or throw "Constant #{name} not found"