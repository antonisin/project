@Air.module 'Accounting.Invoice.Filter', (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.View extends App.BaseItemView
    template: 'accounting/invoice/filter/view'

    events:
      'click .invoice-search': 'submit'

    onShow: ->
      @initComponents()

    initComponents: ->
      @$('.year').datepicker
        format: 'yyyy',
        viewMode: 'years',
        minViewMode: 'years'
        autoclose : true,
        language  : 'ru'

      @$('.month').datepicker
        format: 'mm',
        viewMode: 'months',
        minViewMode: 'months'
        autoclose : true,
        language  : 'ru'

    submit: (e) ->
      e.preventDefault()
      @trigger 'submit', @$('form').serialize()