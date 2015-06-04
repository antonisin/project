@Air.module "Header.User", (User, App, Backbone, Marionette, $, _) ->

  class User.UserMenuController extends App.Base.Controller
    _name: 'header/usermenu'

    initialize: ->
      user = App.request 'get:current:user'

      view = @getView user
      @listenTo view, 'click:profile', => App.vent.trigger 'header:user:profile'
      @listenTo view, 'click:logout',  => App.execute 'goto', 'logout'

      App.vent.on 'user:profile:dates:fetch',  =>
        user.fetch reset:true
        @show view
        user.fetch reset:true

      @show view

      new User.DropdownController
        model: user

    getView: (user) ->
      new User.UserMenuView
        model: user
