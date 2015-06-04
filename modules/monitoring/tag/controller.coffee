@Air.module 'Monitoring.Tag', (Tag, App, Backbone, Marionette, $, _) ->

  class Tag.Controller extends App.Base.Controller
    initialize: (opts) ->
      tags = App.request 'admin:monitoring:categories:collection:all'
      view = @getView tags

      @show view,
        loading:
          entities: [tags]

    getView: (tags) ->
      view = new Tag.View
        tags : tags
        model: @model

      @listenTo view, 'dialog:click:save', ->
        @modelSave view

      view

    modelSave: (view) ->
      if view.$('[name="tag"]:checked').length>0
        @model.set 'tagId', view.$('[name="tag"]:checked').val()
        @loading
        @model.save @model.attributes,
          wait: true,
          success: =>
            App.vent.trigger 'monitoring:tag:sync'
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            @close()
      else
        App.execute 'notify:info', App.request('lang:get','nothing:changed')
        @close()