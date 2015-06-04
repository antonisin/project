@Air.module 'TaskStorage.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Controller extends App.Base.Controller
    _name: 'taskstorage/view'

    initialize: ->
      @layout = @getLayout()

      @listenTo @layout, 'show', =>
        @showCategories()
        @showTasks()

      @show @layout

    getLayout: ->
      new View.Layout

    showCategories: ->
      new View.Categories.Controller
        region: @layout.categories

    showTasks: ->
      new View.Tasks.Controller
        region: @layout.taskStack