@Air.module 'Accounting.Scheme.Preview', (Preview, App, Backbone, Marionette, $, _) ->

  class Preview.Controller extends App.Base.Controller
    _name: 'edit/preview'

    initialize: ->
      view = @getView()

      @show view

    getView: ->
      new Preview.ItemView
        model: @model
