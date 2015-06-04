@Air.module 'Accounting.Invoice', (Invoice, App, Backbone, Marionette, $, _) ->

  class Invoice.Router extends App.Routers.BaseRouter
    menuItem: 'accounting/invoices'
    role: ['admin', 'agent']
    appRoutes:
      'accounting/invoices'    : 'list'
      'accounting/invoices/:id': 'view'

  API =
    list: ->
      new Invoice.List.Controller
        region: App.content

    view: (id, model) ->
      new Invoice.View.Controller
        id: id
        model: model
        region: App.content

    reject: (collection) ->
      new Invoice.View.Reject.Controller
        region: App.dialog
        collection: collection

    filter: (region) ->
      new Invoice.Filter.Controller
        region: region

  App.addInitializer ->
    new Invoice.Router
      controller: API

  App.vent.on 'accounting:invoices:view', (model) ->
    API.view model.id, model

    App.navigate 'accounting/invoices/' + model.id

  App.vent.on 'accounting:invoice:fine:reject', (collection) ->
    API.reject collection

  App.reqres.setHandler 'filter:invoice:view', (region) ->
    API.filter region
