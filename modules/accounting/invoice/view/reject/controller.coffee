@Air.module 'Accounting.Invoice.View.Reject', (Reject, App, Backbone, Marionette, $, _) ->

  class Reject.Controller extends App.Base.Controller
    initialize: (opts) ->
      { collection } = opts

      @show @getView(collection)

    getView: (collection) ->
      view = new Reject.CompositeView
        collection: collection

      @listenTo view, 'dialog:click:save', =>
        if collection.getType() is 'disciplinary'
          App.vent.trigger 'disciplinaryFines:reject', collection
        else
          App.vent.trigger 'fines:reject', collection
        @close()

      @listenTo view, 'modal:hidden', =>
        if collection.getType() is 'disciplinary'
          App.vent.trigger 'disciplinaryFines:dialog:close'
        else
          App.vent.trigger 'fines:dialog:close'

      view