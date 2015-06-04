@Air.module 'Accounting.Scheme.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ItemView extends Air.BaseItemView
    template: 'accounting/scheme/list/item'
    tagName: 'tr'
    triggers:
      'click td:not(".not-click")' : 'scheme:preview'
      'click #edit'   : 'scheme:edit'
      'click #remove' : 'scheme:remove'

    templateHelpers: ->
      modelIndex : @model.collection.indexOf(@model) + 1

    onShow: ->
      @updateUI()

  class List.EmptyView extends Air.BaseItemView
    template: 'accounting/scheme/list/empty'
    tagName: 'tr'

  class List.ComposedView extends Air.BaseCompositeView
    template: 'accounting/scheme/list/list'
    itemView: List.ItemView
    emptyView: List.EmptyView
    itemViewContainer: 'tbody'
    events:
      'click #add' :-> @trigger 'scheme:add', @model

    initialize: ->
      @listenTo @, 'refresh', @render

    onDomRefresh:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#scheme_table',
        ordering: false
        searching: false
        initComplete: (=> @$("#add").prependTo @$("#scheme_table_wrapper .row:first .col-md-6:last"))
