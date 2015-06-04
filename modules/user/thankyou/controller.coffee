@Air.module 'User.Thankyou', (Thankyou, App, Backbone, Marionette, $, _) ->

  class Thankyou.ThankyouController extends App.Base.Controller

    initialize: (curent_user) ->
      if parseInt(curent_user.curent_user) is App.request('get:current:user').id
        App.execute 'notify:error', App.request('lang:get', 'userediterror')
      else
        thank = App.request 'thankyou:entiti', curent_user
        view = @getView thank

        @listenTo view, 'dialog:click:save',  => @onSave view.model
        @listenTo thank, 'validated:invalid', => App.execute 'notify:error', App.request('lang:get', 'usersaveerror')

        @show view

    getView: (thank) ->
      new Thankyou.ThankyouView
        model: thank

    onSave: (model) ->
      model.url = Config.routePrefix + "user/thankyou"
      if !model.validate()
        model.save model.attributes,
          wait: true
          success: =>
            App.execute 'notify:success', App.request('lang:get', 'usersavesuccess')
            $("#dialog").modal('hide')
            App.vent.trigger 'user:profile:thanks:fetch'

