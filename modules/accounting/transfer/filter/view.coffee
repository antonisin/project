@Air.module 'Accounting.Transfer.Filter', (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.View extends App.BaseItemView
    template: 'accounting/transfer/filter/view'

    triggers:
      'click .watch': 'transfer:watch'

    events:
      'change [name="period"]': 'filterDate'
      'click .searchBtn'      : 'search'

    onShow: ->
      @initComponents()

    initComponents: ->
      @initDatePickers startDate: null
      @updateUI()
      @$('[name="minAmount"], [name="maxAmount"]').inputFilter 'number'

    search: (e) ->
      e.preventDefault()
      @trigger 'submit', @$('form').serialize()

    filterDate: ->
      dateFormat = 'DD/MM/YYYY'
      endValue = moment().format dateFormat

      if @$("select[name='period']").val() is 'today'
        startValue = endValue
      else if @$("select[name='period']").val() is 'yesterday'
        startValue = moment().subtract('days', 1).format dateFormat
        endValue = startValue
      else if @$("select[name='period']").val() is 'this-week'
        startValue = moment().startOf('week').format dateFormat
      else if @$("select[name='period']").val() is 'last-week'
        startValue = moment().subtract('weeks', 1).startOf('week').format dateFormat
        endValue = moment().subtract('weeks', 1).endOf('week').format dateFormat
      else if @$("select[name='period']").val() is 'this-month'
        startValue = moment().startOf('month').format dateFormat
      else if @$("select[name='period']").val() is 'last-month'
        startValue = moment().subtract('months', 1).startOf('month').format dateFormat
        endValue = moment().subtract('months', 1).endOf('month').format dateFormat
      else if @$("select[name='period']").val() is 'half-year'
        startValue = moment().subtract('months', 6).format dateFormat
      else if @$("select[name='period']").val() is 'year'
        startValue = moment().subtract('year', 1).format dateFormat

      $("input[name='createdFrom']").val startValue
      $("input[name='createdTill']").val endValue

      @$(".date-picker").datepicker('update')