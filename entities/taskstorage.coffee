@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.TaskCategoryModel extends Entities.BaseModel

  class Entities.TaskCategoriesCollection extends Entities.BaseCollection
    model: Entities.TaskCategoryModel
    url: -> Config.routePrefix + 'task/categories'

  API =
    getDashboardTasks: (range, collection) ->
      if !collection
        collection = new Entities.TasksCollection
      collection.url = Config.routePrefix + 'task/category/' + range
      collection.fetch
        wait: true

      collection

    getTasksCollectionComp: ->
      collection = new Entities.TasksCollection
      collection.fetch()

      collection.comparator = (model) ->
        [-model.get('isPicked'), model.id]

      collection.sort()
      collection

    getCategoriesCollection: ->
      collection = new Entities.TaskCategoriesCollection

      collection.comparator = (model) ->
        model.get('order')

      collection.fetch
        success: (collection) =>
          if window.data?.user?.taskCategoriesOrder?
            for value, index in window.data.user.taskCategoriesOrder
              collection.get(value).set('order', index)
          collection.sort()
      collection

  App.reqres.setHandler 'lid:task:storage:collection', API.getTasksCollectionComp
  App.reqres.setHandler 'dashboard:tasks:collection', API.getDashboardTasks
  App.reqres.setHandler 'lid:categories:collection', API.getCategoriesCollection
