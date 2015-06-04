@Air.module 'Accounting.Invoice.View.DisciplinaryFine', (DisciplinaryFine, App, Backbone, Marionette, $, _) ->

  class DisciplinaryFine.EmptyView extends Air.BaseItemView
    template: 'accounting/invoice/view/disciplinaryfine/empty'
    tagName : 'tr'

  class DisciplinaryFine.ItemView extends Air.BaseItemView
    template: 'accounting/invoice/view/disciplinaryfine/item'
    tagName : 'tr'

    modelEvents:
      'change': 'render'

    className: ->
      if @model.get('isConfirmed') is 1 then 'success' else if @model.get('isRejected') is 1 then 'warning'

    templateHelpers: ->
      order: @model.collection.indexOf(@model) + 1

    events:
      'click .select': 'preSelect'

    initialize: ->
      @listenTo @, 'select',   -> @select()
      @listenTo @, 'unselect', -> @unselect()

    onShow: ->
      @updateUI()

    preSelect: ->
      if @$(".select").prop('checked') is true
        @select()
        @trigger 'item:choose', @model
      else
        @unselect()
        @trigger 'item:unchoose', @model

    select: ->
      if @model.get('isConfirmed') is 0 and @model.get('isRejected') is 0
        @$(".select").prop 'checked', true
        @$el.addClass 'info'

        @updateUniform()

    unselect: ->
      if @model.get('isConfirmed') is 0 and @model.get('isRejected') is 0
        @$(".select").prop 'checked', false
        @$el.removeClass 'info'

        @updateUniform()
  class DisciplinaryFine.TotalsItemView extends Air.BaseItemView
    template: 'accounting/invoice/view/disciplinaryfine/total'
    tagName : 'tr'
    templateHelpers: ->
      totals: @options.totals

  class DisciplinaryFine.CompositeView extends Air.BaseCompositeView
    template : 'accounting/invoice/view/disciplinaryfine/composite'
    itemView : DisciplinaryFine.ItemView
    emptyView: DisciplinaryFine.EmptyView
    itemViewContainer: 'tbody'

    triggers:
      'click #confirmFines': 'fines:confirm'
      'click #rejectFines' : 'fines:reject:dialog'

    events:
      'click #selectAll'    : 'selectAll'

    templateHelpers: ->
      disabled: @options.disabled

    onShow: ->
      @updateUI()
      if !@collection.isEmpty()
        @appendView(new DisciplinaryFine.TotalsItemView({totals:@options.totals}))

    selectAll: ->
      if @collection.getChosen().length == 0
        @$("#selectAll").prop 'checked', true
        @trigger 'choose:all'
        @children.call 'trigger', 'select'
      else
        @$("#selectAll").prop 'checked', false
        @trigger 'unchoose:all'
        @children.call 'trigger', 'unselect'

      @updateUniform()
