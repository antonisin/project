@Air.module 'Admin.OfferLabel', (OfferLabel, App, Backbone, Marionette, $, _) ->

  class OfferLabel.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/offerLabels': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'offerLabels') unless region
      new OfferLabel.List.ListController region: region
      
    edit: (model) ->
      new OfferLabel.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new OfferLabel.Edit.EditController
        region: App.dialog
        model: App.request 'offerlabel:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'offerLabels'

    App.navigate "admin/offerLabels" 
    API.list region 

  App.addInitializer ->
    new OfferLabel.Router
      controller: API

  App.vent.on 'admin:offerLabel:edit', (model) ->
    API.edit model

  App.vent.on 'admin:offerLabel:add',->
    API.add()
