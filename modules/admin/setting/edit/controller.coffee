@Air.module 'Admin.Settings.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditController extends App.Base.Controller
    name: 'admin/settings/edit'

    initialize: (opts) ->
      { model } = opts
      @view = @getView model
      @show @view

    getView: (model) ->
      view = new Edit.EditView
        model: model

      @listenTo @, 'ready:save', =>
        if view.model.hasChanged() or model.isNew()
          @save model
        else if !model.hasChanged()
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          @close()
      view

    save: (model) ->
      if !model.validate()
        @loading()
        model.save model.attributes,
        wait: true,
        success: =>
          @loading()
          App.vent.trigger 'admin:setting:sync'
          App.execute 'notify:success', App.request('lang:get', 'data:save:success')
          @close()
      else
        App.execute 'notify:error', App.request('lang:get','usersaveerror')
