@Air.module "Footer.Lid", (Lid, App, Backbone, Marionette, $, _) ->

  Lid.Controller = 

    view: (region) ->
      view = @getView()
      view.listenTo view, 'click:send:offers', =>
        App.vent.trigger 'footer:lid:send:offers'

      view.listenTo view, 'click:create:sale', =>
        App.vent.trigger 'footer:lid:create:sale'
        
      view.listenTo App.vent, 'booking:offers:sent', =>
        view.trigger 'offers:sent'

      view.listenTo App.vent, 'booking:offers:sending', =>
        view.trigger 'offers:sending'

      view.listenTo App.vent, 'booking:changed', =>
        view.trigger 'booking:ready'

      view.listenTo App.vent, 'booking:ready', =>
        view.trigger 'booking:ready'

      view.listenTo App.vent, 'booking:notready', =>
        view.trigger 'booking:notready'
      
      view.listenTo view, 'error', (text) =>
        App.execute 'notify:error', App.request('lang:get', text)
 
      region.show view

    getView: ->
      new Lid.View
