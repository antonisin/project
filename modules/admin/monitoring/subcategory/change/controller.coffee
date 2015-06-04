@Air.module 'Admin.Monitoring.Subcategory', (Subcategory, App, Backbone, Marionette, $, _) ->
  class Subcategory.Controller extends App.Base.Controller
    name: 'admin/monitoring/subcategory/change'

    initialize: ->
      @view = @getView @model
      @show @view,
        loading:
          entities :[@model]

    getView: (model) ->
      view = new Subcategory.ItemView
        model: model
      @listenTo @, 'ready:save', ->  @modelSave()

      view

    modelSave: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait: true,
          success: =>
            @loading()
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            App.vent.trigger 'admin:monitoring:subcategory:sync'
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')

