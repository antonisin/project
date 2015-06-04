@Air.module 'Lid.SalesPaper', (SalesPaper, App, Backbone, Marionette, $, _) ->

  class SalesPaper.Controller extends App.Base.Controller
    initialize: (salesJSON) ->
      collection = App.request 'lid:sale:paper:collection', salesJSON
      view = @getView collection

      @show view

    getView: (collection) ->
      new SalesPaper.CompositeView
        collection: collection
