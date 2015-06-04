@Air.module 'Base', (Base, App, Backbone, Marionette, $, _) ->

  class Base.Controller extends Backbone.Marionette.Controller

    _spinnerOpts:
      lines: 10 # The number of lines to draw
      length: 5 # The length of each line
      width: 2.0 # The line thickness
      radius: 6 # The radius of the inner circle
      corners: 1 # Corner roundness (0..1)
      rotate: 9 # The rotation offset
      direction: 1 # 1: clockwise, -1: counterclockwise
      color: '#000' # #rgb or #rrggbb
      speed: 1 # Rounds per second
      trail: 60 # Afterglow percentage
      shadow: false # Whether to render a shadow
      hwaccel: true # Whether to use hardware acceleration
      className: 'spinner' # The CSS class to assign to the spinner
      zIndex: 2e9 # The z-index (defaults to 2000000000)
      top: '50%' # Top position relative to parent in px
      left: '50%' # Left position relative to parent in px

    constructor: (options = {}) ->
        @region = options.region
        @model  = options.model unless !options.model
        super options

        @_instance_id = _.uniqueId("controller[#{@_name}]")
        Air.execute "register:instance", @, @_instance_id

    show: (view, opts) ->
      opts = {} if not opts?
      _.defaults opts,
        loading: false,
        region: @region
      if @region.el is '#dialog' then @modalEvents()
      @_setMainView view
      @_manageView view, opts

    modalEvents: ->
      counter = 0;
      if @view then @listenTo @view, 'dialog:click:save', ->
        if counter is 0
          counter++
          @trigger 'ready:save'
        else return false
      if @model
        @listenTo @model, 'validated:invalid', => counter = 0

    _setMainView: (view) ->
      return if @_mainView

      @_mainView = view
      @listenTo view, "close", @close

    _manageView: (view, opts) ->
      if opts.loading
        Air.execute 'show:loading', view, opts
      else
        @region.show view

    close: (args...) ->
        @region.close() if @region?.currentView
        super args
        Air.execute "unregister:instance", @, @_instance_id

    loading: ->
      if @_loader
        @_loader.remove()
        @_mainView.$el.spin false
        @_loader = null
      else
        @_loader = $("<div>").css(
          position: 'absolute'
          left: 0
          top: 0
          right: 0
          bottom: 0
          zIndex: 3333
          background: '#000'
          opacity: 0
        ).prependTo(@_mainView.$el).animate opacity: 0.35, 200
        @_mainView.$el.spin @_spinnerOpts

    sendXHR: (url) ->
      xhr = new XMLHttpRequest()
      xhr.open("PATCH", Config.routePrefix + url, true)
      xhr.send()

    save: (success, error) ->
      @loading()
      @model.save @model.attributes,
        wait: true
        success: =>
          @loading()
          if success
            App.execute 'notify:success', App.request('lang:get', success)
          else
            App.execute 'notify:success', App.request('lang:get', 'save:success')

          App.vent.trigger 'saved:success',  @model

        error: =>
          @loading()
          if error
            App.execute 'notify:error', App.request('lang:get', error)
          else
            App.execute 'notify:error', App.request('lang:get', 'save:error')
