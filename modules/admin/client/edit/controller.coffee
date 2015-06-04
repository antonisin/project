@Air.module 'Admin.Client.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditController extends App.Base.Controller
    name: 'admin/clients/edit'

    initialize: (opts) ->
      { model } = opts
      layout    = @getLayout model

      hitsCollection = App.request 'client:hits:entities', id: model.id

      @listenTo layout, 'show', =>
        @getHits layout.hits, model, hitsCollection
      
      @show layout, 
        loading:
          entities: [hitsCollection]

    getLayout: (model) ->
      new Edit.EditLayout 
        model: model

    getHits: (region, model, hitsCollection) ->
      App.request 'admin:client:hits:view',
        collection: hitsCollection
        region: region
