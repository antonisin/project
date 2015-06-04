@Air.module 'Utils.Notifications', (Notifications, App, Backbone, Marionette, $, _) ->

  API = 

    info: (text) ->
      toastr.info text

    error: (text) ->
      toastr.error text

    success: (text) ->
      toastr.success text

  App.commands.setHandler 'notify:error', (text) =>
    API.error text

  App.commands.setHandler 'notify:success', (text) =>
    API.success text

  App.commands.setHandler 'notify:info', (text) =>
    API.info text

  App.addInitializer ->
    toastr.options.closeButton = true
    toastr.options.showDuration = 300
    toastr.options.timeOut = 2000