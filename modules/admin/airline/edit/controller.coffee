@Air.module 'Admin.Airline.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditController extends App.Base.Controller
    name: 'admin/airlines/edit'

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
      @listenTo model, 'validated:invalid', => App.execute 'notify:error', App.request('lang:get', 'airline:save:error')
      view

    save: (model) ->
      @loading()
      model.save model.attributes, 
        wait: true,
        success: =>
          @loading() 
          App.vent.trigger 'admin:airline:sync'
          App.execute 'notify:success', App.request('lang:get', 'airline:save:success')
          @close()        