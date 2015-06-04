@Air.module 'Accounting.Fine', (Fine, App, Backbone, Marionette, $, _) ->

  class Fine.Router extends App.Routers.BaseRouter
    menuItem: 'accounting/invoices'

    appRoutes:
      'accounting/fines': 'list'

    API =
      list: ->
        new Fine.List.Controller
          region: App.content

      new: (region, model, agent, type) ->
        new Fine.New.Controller
          region: region
          model: model
          agent: agent
          type: type

      filter: (region) ->
        new Fine.Filter.Controller
          region: region

    App.addInitializer ->
      new Fine.Router
        controller: API

    App.reqres.setHandler 'new:fine:view', (region, agent, model, type) ->
      API.new region, model, agent, type

    App.reqres.setHandler 'filter:fine:view', (region) ->
      API.filter region