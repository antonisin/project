@Air.module "Header", (Header, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API = 
    loading: 0

    init: ->
      @layout = @getLayout()
      @layout.on 'show', =>
        new Header.Menu.MenuController { region: @layout.menu }
        new Header.User.UserMenuController { region: @layout.user }
      App.header.show @layout

    getLayout: ->
      new Header.Layout

    loadingStart: ->
      @layout.trigger 'loading:show' if @loading is 0
      ++@loading

    loadingDone: ->
      --@loading
      @layout.trigger 'loading:hide' if @loading is 0

  Header.on 'start', -> 
    API.init()

  App.vent.on 'menu:loading:start', => API.loadingStart()
  App.vent.on 'menu:loading:done', => API.loadingDone()