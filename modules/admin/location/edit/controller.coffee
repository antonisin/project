@Air.module 'Admin.Location.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditController extends App.Base.Controller
    name: 'admin/locations/edit'

    initialize: (opts) ->
      { model } = opts

      countries = App.request 'country:entities'
      @view = @getView model, countries

      @listenTo @view, 'show', =>
        @showAirports @view, model

      @show @view,
        loading:
          entities: [model, countries]

    getView: (model, countries) ->
      view = new Edit.EditView
        model     : model
        countries : countries

      @listenTo @, 'ready:save', =>
        if view.model.hasChanged() or model.isNew()
          @save model
        else if !model.hasChanged()
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          @close()

      view

    showAirports: (view, model) ->
      airportsView = App.request 'admin:locations:airports',
        region: view.airports
        collection: App.request 'location:entities:airports', model.get('airports')

    save: (model) ->
      model.validate()
      if model.isValid()
        @loading()
        model.save model.attributes,
          wait: true,
          success: =>
            @loading()
            App.vent.trigger 'admin:location:sync'
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')
