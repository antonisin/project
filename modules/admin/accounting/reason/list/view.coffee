@Air.module 'Admin.Reason.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ItemView extends Air.BaseCompositeView
    template: 'admin/accounting/reason/item'
    tagName : 'tr'

    modelEvents:
      'sync': 'render'

    initialize: ->
      @model.set('order', @model.collection.indexOf(@model) + 1)

    events:
      'click td'      : -> @trigger 'click:edit', @model
      'click #delete' : (e) ->
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model

  class List.EmptyView extends Air.BaseItemView
    template: "admin/accounting/reason/empty"
    tagName : "tr"

  class List.CompositeView extends Air.BaseCompositeView
    template         : 'admin/accounting/reason/list'
    itemView         : List.ItemView
    emptyView        : List.ListEmptyView
    itemViewContainer: 'tbody'

    triggers:
      'click #add'        : 'item:add'

    initialize: ->
      @listenTo @, 'refresh', @render

    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable',
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
