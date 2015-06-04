@Air.module 'Utils', (Utils, App, Backbone, Marionette, $, _) ->

  class Utils.LoadingController extends App.Base.Controller
    _name: 'loading'

    initialize: (opts) ->
      { view, config } = opts

      config = if _.isBoolean(config) then {} else config

      _.defaults config,
        type: "spinner"
        entities: @getEntities view
        debug: false

      config.type = "spinner" unless @region.currentView

      switch config.type
        when "opacity"
          @region.currentView.$el.css "opacity", 0.5
        when "spinner"
          loadingView = @getLoadingView()
          @show loadingView
        else
          throw new Error "Invalid loadingType"

      App.vent.trigger 'menu:loading:start'
      App.execute "when:fetched", config.entities, (=> @showRealView(view, loadingView, config)), (=>)
      @listenTo App.vent, 'loading:hide', => @showRealView(view, loadingView, config)

    showRealView: (realView, loadingView, config) ->
      switch config.type
        when "opacity"
          @region.currentView.$el.removeAttr "style"
        when "spinner"
          return realView.close() if @region.currentView isnt loadingView

      @show realView unless config.debug
      App.vent.trigger 'menu:loading:done'

    getEntities: (view) ->
      _.chain(view).pick("model", "collection").toArray().compact().value()

    getLoadingView: ->
      new Loading.LoadingView

    getLoadingView: ->
      new Utils.LoadingView


  class Utils.LoadingView extends Air.BaseItemView
    template: false
    className: 'loading-container'

    onShow: ->
      opts =
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

      @$el.spin opts

    onClose: ->
      @$el.spin false

  App.commands.setHandler 'show:loading', (view, opts) ->
    new Utils.LoadingController
      region: opts.region
      view  : view
      config: opts.loading

