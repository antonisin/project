@Air.module 'Accounting.Transfer', (Transfer, App, Backbone, Marionette, $, _) ->

  class Transfer.Router extends App.Routers.BaseRouter
    menuItem: 'accounting/invoices'

    appRoutes:
      'accounting/transfers': 'transfers'

    API =
      new: (region) ->
        new Transfer.New.Controller
          region: region

      filter: (region) ->
        new Transfer.Filter.Controller
          region: region

      transfers: ->
        new Transfer.List.Controller
          region: App.content

      assign: (model) ->
        new Transfer.Assign.Controller
          region: App.dialog
          model: model

      watch: ->
        new Transfer.Watch.Controller
          region: App.dialog

    App.addInitializer ->
      new Transfer.Router
        controller: API

    App.reqres.setHandler 'transfer:filter', (region) ->
      API.filter region

    App.reqres.setHandler 'transfer:new', (region) ->
      API.new region

    App.reqres.setHandler 'transfer:assign', (model) ->
      API.assign model

    App.reqres.setHandler 'transfer:watch', ->
      API.watch()