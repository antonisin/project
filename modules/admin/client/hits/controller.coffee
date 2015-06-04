@Air.module 'Admin.Client.Hits', (Hits, App, Backbone, Marionette, $, _) ->

  class Hits.HitsController extends App.Base.Controller

    initialize: (opts) ->
      { collection } = opts
      if collection.length > 0
        view = @getView collection
        @show view

    getView: (collection) ->
      new Hits.HitsCollectionView
        collection: collection

    App.reqres.setHandler 'admin:client:hits:view', (opts) =>
      new Hits.HitsController opts