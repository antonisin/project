@Air.module 'Preference.Sidebar', (Sidebar, App, Backbone, Marionette, $, _) ->

  class Sidebar.Controller extends App.Base.Controller
    initialize: ->
      collection =  App.request 'preference:sidebar:collection'

      view = @getView collection

      @show view,
        loading:
          entities: [collection]

    getView: (collection) ->
      new Sidebar.CollectionView
        collection: collection
        menuItem: @options.menuItem