@Air.module 'User.Dashboard.Header', (Header, App, Backbone, Marionette, $, _) ->

  class Header.HeaderController extends App.Base.Controller
    _name: 'dashboard/header'

    initialize: (opts) ->
      { user } = opts
      counter =  App.request 'get:user:counter', user.id
      view = @getView user,counter
      @show view,
        loading:
          entities: [user,counter]

      @listenTo view, 'click:save', (model) => @onSave model;
     

    getView: (user,counter) ->
      new Header.HeaderView
        model: user
        counterModel: counter

    onSave: (model) ->
    	model.save()
    	