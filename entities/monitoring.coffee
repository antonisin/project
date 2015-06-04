@Air.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.InlineCollection  extends Entities.BaseCollection
    url  : Config.routePrefix + 'asterisk/inline'

  class Entities.InorderCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'asterisk/inorder'

  class Entities.OutlineCollection extends Entities.BaseCollection
    url  : Config.routePrefix + 'asterisk/outline'

  class Entities.ArchiveCollection extends Entities.BaseCollection

  class Entities.MonitoringSubcategoryModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'monitoring/subcategory/'
    defaults:
      name : ""
    validation:
      name:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid first name'

  class Entities.MonitoringSubcategoriesCollection extends Entities.BaseCollection
    model: Entities.MonitoringSubcategoryModel

  class Entities.MonitoringCategoryModel extends Entities.BaseModel
    urlRoot     : Config.routePrefix + 'monitoring/category/'
    defaults:
      name : ""
    validation:
      name:
        required: true
        rangeLength: [3, 20]
        msg: 'Please enter a valid first name'

  class Entities.MonitoringCategoriesCollection extends Entities.BaseCollection
    model: Entities.MonitoringCategoryModel
    url : Config.routePrefix + 'monitoring/categories'

  API =
    getInlineCollection: ->
      collection = new Entities.InlineCollection
      collection.fetch()
      collection

    getInorderCollection: ->
      collection = new Entities.InorderCollection
      collection.fetch()
      collection

    getOutlineCollection: ->
      collection = new Entities.OutlineCollection
      collection.fetch()
      collection

    getArchiveCollection: (sipId) ->
      collection = new Entities.ArchiveCollection
      collection.url = Config.routePrefix + 'asterisk/archive/' + sipId
      collection.fetch()
      collection

    getMonitoringCategoryModel: ->
       new Entities.MonitoringCategoryModel

    getMonitoringCategoriesCollection: ->
      collection = new Entities.MonitoringCategoriesCollection
      collection.fetch()
      collection

    getMonitoringCategoriesCollectionAll: ->
      collection = new Entities.MonitoringCategoriesCollection
      collection.url = Config.routePrefix + 'monitoring/categories/all'
      collection.fetch()
      collection

    getMonitoringSubcategoriesCollectionAll: ->
      collection = new Entities.MonitoringSubcategoriesCollection
      collection.url = Config.routePrefix + 'monitoring/subcategories/all'
      collection.fetch()
      collection

    getMonitoringSubcategoryModel: (categoryId) ->
      model         = new Entities.MonitoringSubcategoryModel
      model.urlRoot = model.urlRoot + categoryId
      model

    getMonitoringSubcategoriesCollection: (categoryId) ->
      collection     = new Entities.MonitoringSubcategoriesCollection
      if categoryId
        collection.url = Config.routePrefix + 'monitoring/subcategories/' + categoryId
        collection.fetch()
      collection

  App.reqres.setHandler 'monitoring:inline:entity', API.getInlineCollection
  App.reqres.setHandler 'monitoring:inorder:entity', API.getInorderCollection
  App.reqres.setHandler 'monitoring:outline:entity', API.getOutlineCollection

  App.reqres.setHandler 'monitoring:archive:entitie'  , API.getArchiveCollection

  App.reqres.setHandler 'admin:monitoring:category:model'  , API.getMonitoringCategoryModel
  App.reqres.setHandler 'admin:monitoring:categories:collection'  , API.getMonitoringCategoriesCollection
  App.reqres.setHandler 'admin:monitoring:categories:collection:all'  , API.getMonitoringCategoriesCollectionAll
  App.reqres.setHandler 'monitoring:subcategories:collection:all'  , API.getMonitoringSubcategoriesCollectionAll

  App.reqres.setHandler 'admin:monitoring:subcategory:model'  , API.getMonitoringSubcategoryModel
  App.reqres.setHandler 'admin:monitoring:subcategories:collection'  , API.getMonitoringSubcategoriesCollection