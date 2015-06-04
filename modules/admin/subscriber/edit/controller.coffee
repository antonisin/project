@Air.module 'Admin.Subscriber.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditController extends App.Base.Controller
    name: 'admin/subscribers/edit'

    initialize: (opts) ->
      { model, @collection } = opts
      @view = @getView model
      @show @view,
        loading:
          entities :[@collection]

    getView: (model) ->
      view = new Edit.EditView
        model: model

      @listenTo @, 'ready:save', =>
        if model.hasChanged() or model.isNew()
          @save model
        if !model.hasChanged() and !model.isNew()
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          @close()

      view

    save: (model) ->
      model.validate()
      if model.isValid()
        if @checkEmail model
          model.save model.atributtes,
            success : =>
              App.execute 'notify:success', App.request('lang:get', 'data:save:success')
              App.vent.trigger 'admin:subscriber:sync', model
          @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'subscriber:save:error')

    checkEmail: (model) ->
      find = @collection.where({'email': model.get('email')})
      if find.length > 0 and find[0].id != model.id
        App.execute 'notify:error', App.request('lang:get', 'subscriber:save:error2')
        model.view.$('input[name="email"]').addClass 'has-error'
        return false
      model.view.$('input[name="email"]').removeClass 'has-error'
      true
