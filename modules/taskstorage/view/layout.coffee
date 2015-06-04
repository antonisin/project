@Air.module 'TaskStorage.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Layout extends Air.BaseLayout
    template: 'taskstorage/view/layout'
    regions:
      categories: '#categories'
      taskStack: '#task-stack'
