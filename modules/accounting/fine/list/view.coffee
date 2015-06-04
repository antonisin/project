@Air.module 'Accounting.Fine.List', (List, App, Backbone, Marionette, $, _) ->

  class List.ItemView extends App.BaseItemView
    template: 'accounting/fine/list/fine_item'
    tagName: 'tr'

    modelEvents:
      'sync': 'render'

    events:
      'click .edit'  : 'edit'
      'click .delete': 'delete'

    initialize: ->
      @model.set('order', @model.collection.indexOf(@model) + 1)

      if @model.getType() is 'disciplinary'
        @template = 'accounting/fine/list/disciplinary_item'

    delete: (e) ->
      e.stopImmediatePropagation()
      @trigger 'click:delete', @model

    edit: (e) ->
      e.stopImmediatePropagation()
      @trigger 'click:edit', @model
      @disable()

    disable: ->
      $('.delete, .edit').removeClass 'disabled'
      @$('.delete, .edit').addClass 'disabled'

  class List.EmptyView extends App.BaseItemView
    template: 'accounting/fine/list/fine_empty'
    tagName : 'tr'

  class List.DisciplinaryEmptyView extends App.BaseItemView
    template: 'accounting/fine/list/disciplinary_empty'
    tagName : 'tr'

  class List.CompositeView extends App.BaseCompositeView
    template : 'accounting/fine/list/fine_composite'
    itemView : List.ItemView
    emptyView: List.EmptyView
    itemViewContainer: 'tbody'

    triggers:
      'click #search': 'search:button:clicked'

    initialize: ->
      @listenTo @collection, 'add', -> @render
      @listenTo @collection, 'destroy', -> @render

      if @collection.getType() is 'disciplinary'
        @template = 'accounting/fine/list/disciplinary_composite'
        @emptyView = List.DisciplinaryEmptyView

    templateHelpers: ->
      agent: @options.agent

    onShow: ->
      @updateUI()
      App.Utils.DT.initDT '#fineTable',
        order: [0, 'desc']
        searching: false
