@Air.module 'User', (User, App, Backbone, Marionette, $, _) ->

  class User.Router extends App.Routers.BaseRouter
    menuItem: 'dashboard'
    appRoutes:
      'profile'     : 'myprofile'
      'profile/:id' : 'profile'
      "dashboard"   : "dashboard"

  API = 
    myprofile: ->
      @profile null, App.request('get:current:user')

    profile: (id, model) ->
      new User.Profile.ProfileController 
        id    : id
        model : model
        region: @getRegion()
      App.vent.trigger 'footer:view:default'

    dashboard: ->
      new User.Dashboard.DashboardController region: App.content
      App.vent.trigger 'footer:view:default'

    edit: (model) ->
      new User.Edit.EditController 
        region  : App.dialog
        model   : model
        editable: parseInt(model.id) is App.request('get:current:user').id

    thankyou: (model) ->
      curentUser = App.request 'get:current:user'

      new User.Thankyou.ThankyouController
        region        : App.dialog
        curent_user   : model.attributes.id
        reference_id  : curentUser.attributes.id

    getRegion: ->
      App.content

  App.addInitializer ->
    new User.Router
      controller: API

    App.vent.on 'header:user:profile', =>
      @navigate 'profile'
      API.myprofile()

    App.vent.on 'user:profile:view', (model) =>
      @navigate "profile/#{model.id}"
      API.profile null, model

    App.vent.on 'user:profile:edit', (model) =>
      API.edit model

    App.vent.on 'thankyou:show', (model) =>
      API.thankyou model  

    
