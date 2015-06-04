@Air.module "Header.Menu", (Menu, App, Backbone, Marionette, $, _) ->

  class Menu.MenuController extends App.Base.Controller
    _name: 'header/menu'

    initialize: ->
      collection = App.request "header:menu:entities"

      @view = @getMenuView collection
      @show @view

      App.vent.on 'menu:choose', (item) =>
        @view.trigger 'navigate', item

    forceNavigate: (route) ->
      menuItem = App.request 'header:menu:entity', route
      @view.trigger 'navigate', menuItem if menuItem

    getMenuView: (collection) ->
      new Menu.MenuView
        collection: collection