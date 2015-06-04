@Air.module 'Preference.Tags.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.Controller extends App.Base.Controller
    initialize: ->
      @view = @getView()

      @listenTo @view, 'change:tag:icon', (value) =>
        @model.set('icon', value)
      @listenTo @, 'ready:save', =>
        @save()

      @show @view

    getView: ->
      new Change.ItemView
        model: @model

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait:true
          success: (model) =>
            @loading()
            @close()
            App.vent.trigger 'preference:tags:add:model', model
            App.execute 'notify:success', App.request('lang:get', 'save:success')
      else
        App.execute 'notify:error', App.request('lang:get', 'validation:error')

