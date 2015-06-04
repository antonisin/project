@Air.module 'Admin.Landings.Add', (Add, App, Backbone, Marionette, $, _) ->
  class Add.AddController extends App.Base.Controller
    name: 'admin/langings/add'

    initialize: (opts) ->
      @model      = opts.model
      @directions = App.request 'landing:directions:entitie'
      @view       = @getView()
      @show @view,
        loading:
          type: 'opacity'
          entities: [@directions]

    getView: ->
      view = new Add.AddView
        model     : @model
        directions: @directions

      @listenTo @, 'ready:save',  => if !@model.isNew() then @save @model
      view

    save: (model) ->
      model.validate()
      if model.isValid()
        @loading()
        model.save model.attributes,
          wait: true,
          success: =>
            App.vent.trigger 'admin:landing:sync'
            @loading()
            App.execute 'notify:success', App.request('lang:get', 'landing:direction:save:success')
            # App.vent.trigger 'admin:landing:new', @model
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')