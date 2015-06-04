@Air.module 'Admin.Referal.List', (List, App, Backbone, Marionette, $, _) ->
  class List.ListItemView extends Air.BaseCompositeView
    template  : 'admin/engine/referal/item'
    tagName   : 'tr'

    events:
      'click td'      : -> @trigger 'click:edit', @model
      'click #edit'   : (e) ->
        e.stopImmediatePropagation()
        @trigger 'click:edit', @model

      'click #delete'   : (e) ->
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model

  class List.ListEmptyView extends Air.BaseItemView
    template          : "admin/engine/referal/empty"
    tagName           : "tr"

  class List.ListView extends Air.BaseCompositeView
    template              : 'admin/engine/referal/list'
    itemView              : List.ListItemView
    emptyView             : List.ListEmptyView
    itemViewContainer     : 'tbody'

    triggers:
      'click #add'        : 'item:add'

    initialize: (model) ->
      @listenTo @, 'refresh', @render
      
    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable', 
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
