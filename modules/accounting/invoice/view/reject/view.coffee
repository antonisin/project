@Air.module 'Accounting.Invoice.View.Reject', (Reject, App, Backbone, Marionette, $, _) ->

  class Reject.ItemView extends Air.BaseItemView
    template: 'accounting/invoice/view/reject/item'
    tagName : 'tr'

    initialize: ->
      @model.set('order', @model.collection.indexOf(@model) + 1)
      @template = 'accounting/invoice/view/reject/disciplinary' if @model.getType() is 'disciplinary'

    events:
      'change #rejectComment': 'setComment'

    setComment: (el) ->
      @model.set 'rejectComment', el.target.value

  class Reject.CompositeView extends Air.BaseCompositeView
    id: 'rejectTable'
    template : 'accounting/invoice/view/reject/composite'
    itemView : Reject.ItemView
    tagName  : 'table'
    className: 'table table-striped table-bordered table-hover table-full-width'
    itemViewContainer: 'tbody'

    dialog: ->
      title: 'Отклонение штрафов'

    initialize: ->
      @template = 'accounting/invoice/view/reject/disciplinaryComposite' if @collection.getType() is 'disciplinary'