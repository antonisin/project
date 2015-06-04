@Air.module 'Accounting.Scheme', (Scheme, App, Backbone, Marionette, $, _) ->

  class Scheme.Router extends App.Routers.BaseRouter
    menuItem: 'accounting/invoices'

    appRoutes:
      'accounting/schemes' : 'schemes'

  API =
    schemes: ->
      new Scheme.List.Controller
        region: App.content

    dialog: (model) ->
      new Scheme.Edit.Controller
        region: App.dialogLarge
        model : model

    preview: (model) ->
      new Scheme.Preview.Controller
        region: App.dialog
        model : model

  App.addInitializer ->
    new Scheme.Router
      controller: API

  App.vent.on 'accounting:scheme:add', ->
    API.dialog((App.request 'scheme:entity'))

  App.vent.on 'accounting:scheme:edit', (model)->
    API.dialog model

  App.vent.on 'accounting:scheme:preview', (model) ->
    API.preview model
