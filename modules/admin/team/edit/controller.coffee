@Air.module 'Admin.Team.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditController extends App.Base.Controller
    name: 'admin/teams/edit'

    initialize: (opts) ->
      { model } = opts
      view = @getView model
      
      @show view

    getView: (model) ->
      view = new Edit.EditView 
        model: model
     
      @listenTo view, 'dialog:click:save', => 
        if view.model.hasChanged()
          @save model
        else
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed') 
          @close()

      @listenTo model, 'validated:invalid', => App.execute 'notify:error', App.request('lang:get', 'team:save:error')
      view

    save: (model) ->
      if !model.validate()
        @loading()
        model.save model.attributes,
          wait: true,
          success: (newModel) =>
            @loading()
            App.vent.trigger 'admin:team:added', newModel
            App.execute 'notify:success', App.request('lang:get', 'team:save:success')
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'fine:save:error')
