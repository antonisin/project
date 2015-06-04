@Air.module 'TaskStorage.View.Categories', (Categories, App, Backbone, Marionette, $, _) ->

  class Categories.ItemView extends Air.BaseItemView
    template: 'taskstorage/view/categories/item'
    tagName : 'li'

    events:
      'click a': 'changeCategory'

    changeCategory: (e) ->
      @trigger 'taskstorage:remove:class'
      App.vent.trigger 'taskstorage:change:category', e.currentTarget.getAttribute('data-id')

  class Categories.CollectionView extends Air.BaseCollectionView
    itemView: Categories.ItemView
    tagName : 'ul'
    className: 'ver-inline-menu'

    behaviors:
      Sortable: {}

    initialize: ->
      @listenTo @ ,'childview:taskstorage:remove:class', (view) ->
        @$el.find('li').removeClass 'active'
        view.$el.addClass 'active'
