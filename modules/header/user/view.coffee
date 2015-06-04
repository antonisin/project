@Air.module "Header.User", (User, App, Backbone, Marionette, $, _) ->

  class User.UserMenuView extends Air.BaseItemView
    template    : 'header/user/view'
    tagName     : 'ul'
    className   : 'nav navbar-nav pull-right'

    events:
      'click #profile': 'clickProfile'
      'click #logout'   : 'clickLogout'

    clickProfile: (e) ->
      e.preventDefault()
      @trigger 'click:profile'

    clickLogout: (e) ->
      e.preventDefault()
      @trigger 'click:logout'
