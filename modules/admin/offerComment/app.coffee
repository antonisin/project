@Air.module 'Admin.OfferComment', (OfferComment, App, Backbone, Marionette, $, _) ->

  class OfferComment.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/offerComments': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'offerComments') unless region
      new OfferComment.List.ListController region: region
      
    edit: (model) ->
      new OfferComment.Edit.EditController
        region: App.dialog
        model: model

    add: ->
      new OfferComment.Edit.EditController
        region: App.dialog
        model: App.request 'offercomment:entity'

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'offerComments'

    App.navigate "admin/offerComments" 
    API.list region 

  App.addInitializer ->
    new OfferComment.Router
      controller: API

  App.vent.on 'admin:offerComment:edit', (model) ->
    API.edit model

  App.vent.on 'admin:offerComment:add',->
    API.add()
