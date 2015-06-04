@Air.module 'Admin.Monitoring.ChangeCategory', (ChangeCategory, App, Backbone, Marionette, $, _) ->
  class ChangeCategory.SubategoryItemView extends Air.BaseItemView
    template  : 'admin/monitoring/subcategory/item'
    tagName   : 'tr'
    events:
      'click #edit': -> @trigger 'model:edit', @model
      'click #delete': -> @trigger 'click:delete', @model

  class ChangeCategory.SubategoryListEmptyView extends Air.BaseItemView
    template          : "admin/monitoring/subcategory/empty"
    tagName           : "tr"

  class ChangeCategory.SubategoryListView extends Air.BaseCompositeView
    template              : 'admin/monitoring/subcategory/list'
    itemView              : ChangeCategory.SubategoryItemView
    emptyView             : ChangeCategory.SubategoryListEmptyView
    itemViewContainer     : 'tbody'

    events:
      'click #add': -> @trigger 'click:add'

    initialize: ->
      @listenTo @, 'refresh', @render
      @listenTo @, 'enable:add:button', -> @$el.find('#add').removeClass('disabled')

    onDomRefresh:->
      @initDT()
      if @collection.length > 0 then @$el.find('#add').removeClass('disabled')

    initDT: ->
      App.Utils.DT.initDT '#lidstable',
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
