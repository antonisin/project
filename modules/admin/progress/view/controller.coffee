@Air.module 'Admin.Progress.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Controller extends App.Base.Controller
    name: 'admin/progress/view'

    initialize: ->
      collection = App.request 'admin:progress:collection'

      @listenTo App.vent, 'saved:success', (model) ->
        collection.add model,
          merge: true
        collection.reset collection.models

      view = @getView collection

      @show view,
        loading:
          entities: [collection]

    getView: (collection) =>
      new View.CompositeView
        collection: collection
