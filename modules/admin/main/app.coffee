@Air.module 'Admin.Main', (Main, App, Backbone, Marionette, $, _) ->
  class Main.Router extends App.Routers.BaseRouter
    menuItem  : 'admin'
    role      : ['admin']
    appRoutes :
      'admin/main': 'list'

  API = 
    list: (region) ->
      return App.execute('admin:list', 'main') unless region
      new Main.List.ListController region: region

    addSlider:  ->
      new Main.Add.AddSliderController
        region          : App.dialog

    addTestimonial: (opts) ->
      if opts
        new Main.Add.AddTestimonialController
          region          : App.dialog
          model           : opts.model
      else
        new Main.Add.AddTestimonialController
          region : App.dialog

  App.vent.on 'admin:navigate', (action, region) =>
    return unless action is 'main'

    App.navigate "admin/main" 
    API.list region 

  App.addInitializer ->
    new Main.Router
      controller: API
  
  App.vent.on 'admin:main:slider:new:model', ->
    API.addSlider()
  
  App.vent.on 'admin:main:testimonial:new:model', ->
    API.addTestimonial()

  App.vent.on 'admin:main:testimonial:edit', (model) ->
    API.addTestimonial model


    