@Air = do (Backbone, Marionette) ->


  Air = new Backbone.Marionette.Application

  Air.Behaviors = {}

  Marionette.Behaviors.behaviorsLookup = ->
    Air.Behaviors

  Air.rootRoute = 'dashboard'

  Air.addInitializer (opts) ->
    @initRouting opts
    @module("Header").start()
    @module("Footer").start()

  Air.on 'initialize:before', (opts) ->
    @execute 'logger:start', Config.env
    @execute 'logger:info', 'init started'

    @currentUser = @request 'set:current:user', opts.user
    @lang = opts.lang
    @environment = Config.env

    @addRegions
      content     : "#content"
      header      : "#header"
      footer      : "#footer"
      dialog      : Marionette.Region.Dialog.extend el: "#dialog"
      dialogLarge : Marionette.Region.Dialog.extend el: "#dialogLarge"

  Air.on 'initialize:after', (opts) ->
    @initComponents opts
    @startHistory()
    @navigate @rootRoute, { trigger: true, force: true } unless @getCurrentRoute()
    @vent.trigger 'app:navigate', @getCurrentRoute()
    @execute 'logger:info', 'init finished'

  Air.reqres.setHandler 'get:current:user', ->
    Air.currentUser

  Air.reqres.setHandler 'locales:list', ->
    window.data.locales

  Air.reqres.setHandler 'user:refresh',(model) ->
    Air.currentUser = model

  Air.commands.setHandler "register:instance", (instance, id) ->
    Air.register instance, id if Air.environment is "dev"

  Air.commands.setHandler "unregister:instance", (instance, id) ->
    Air.unregister instance, id if Air.environment is "dev"

  Air.initComponents = (opts) ->
      @lang = opts.lang

      $.ajaxSetup { cache: false }
      moment.lang(opts.lang) if moment?

      App.init()

  Air.initRouting = (opts) ->
      startUrl = Config.routePrefix

      # IE fallback
      unless window.history and window.history.pushState
        window.location.hash = window.location.pathname.replace startUrl, ''
        startUrl = window.location.pathname



  Air