@Air.module 'Admin.Lids', (Lids, App, Backbone, Marionette, $, _) ->

  class Lids.ListItemView extends Air.BaseItemView
    template: 'admin/lids/item'
    tagName   : 'tr'
    events    :
      'click td'        :     -> @trigger 'item:click', @model
      'click #delete'   : (e) -> 
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model

  class Lids.ListEmptyView extends Air.BaseItemView
    template          : "admin/lids/empty"
    tagName           : "tr"

  class Lids.ListView extends Air.BaseCompositeView
    template              : 'admin/lids/list'
    itemView              : Lids.ListItemView
    emptyView             : Lids.ListEmptyView
    itemViewContainer     : 'tbody'

    initialize: ->
      @listenTo @, 'refresh', @render

    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable', 
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))