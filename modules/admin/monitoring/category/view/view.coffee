@Air.module 'Admin.Monitoring.Category', (Category, App, Backbone, Marionette, $, _) ->
  class Category.ListItemView extends Air.BaseItemView
    template  : 'admin/monitoring/category/item'
    tagName   : 'tr'
    events:
      'click td:not(".notClick")': -> @trigger 'click:edit', @model
      'click #delete': -> @trigger 'click:delete', @model

  class Category.ListEmptyView extends Air.BaseItemView
    template          : "admin/monitoring/category/empty"
    tagName           : "tr"

  class Category.ListView extends Air.BaseCompositeView
    template              : 'admin/monitoring/category/list'
    itemView              : Category.ListItemView
    emptyView             : Category.ListEmptyView
    itemViewContainer     : 'tbody'
    events:
      'click #add' : -> @trigger 'click:add'

    initialize: ->
      @listenTo @, 'refresh', @render

    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable',
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
