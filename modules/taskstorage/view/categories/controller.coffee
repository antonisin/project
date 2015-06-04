@Air.module 'TaskStorage.View.Categories', (Categories, App, Backbone, Marionette, $, _) ->

  class Categories.Controller extends App.Base.Controller
    _name: 'taskstorage/view/categories'

    initialize: ->
      @collection = App.request 'lid:categories:collection'

      view = @getView()

      @show view,
        loading:
          entities: [@collection]

    getView: ->
      new Categories.CollectionView
        collection: @collection
