@Air.module 'Lid.ChangeTask.AddComment', (AddComment, App, Backbone, Marionette, $, _) ->

  class AddComment.Controller extends App.Base.Controller
    initialize: ->
      @view = @getView()

      @listenTo @, 'ready:save', =>
        @save()

      @show @view

    getView: ->
      new AddComment.ItemView
        model: @model

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait:true
          success: (model) =>
            @loading()
            @close()
            App.vent.trigger 'task:add:model:in:collection' + model.get('taskId'), model
            App.execute 'notify:success', App.request('lang:get', 'task:comment:save:success')
      else
        App.execute 'notify:error', App.request('lang:get', 'validation:error')
