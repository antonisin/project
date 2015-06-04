@Air.module 'Accounting.Fine.Filter', (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.View extends App.BaseItemView
    template: 'accounting/fine/filter/view'
    _modelBinder: undefined

    events:
      'submit'                : 'submit'
      'click #advanced'       : 'advanced'
      'change [name="period"]': 'filterDate'
      'click #reset'          : 'reset'

    onShow: ->
      @initComponents()

    initComponents: ->
      @initDatePickers startDate: null
      @updateUI()
      @initSelect2()

    initSelect2: ->
      @$("[name='agent']").select2
        allowClear: true
        minimumInputLength: 1
        placeholder: "Имя агента"
        escapeMarkup: (m) -> m
        ajax:
          url: Config.routePrefix + "user/search"
          dataType: 'json'
          data: (q, p) ->
            q: q
          results: (d, p) ->
            results: _.map d, (el) ->
              {id: el.id, text: el.firstName + " " + el.lastName}

    reset: (e) ->
      @$(':input:not(:button):not(:checkbox):not(:submit):not(:radio)').val ''
      @$('.select2-container').select2 'val', ''
      @submit e

    advanced: ->
      @$el.find("#advanced").tooltip 'hide'
      @$("#search_detailed").slideToggle()
      $('#advanced').find("i.change").toggleClass 'fa-chevron-up fa-chevron-down'

    submit: (e) ->
      e.preventDefault()
      @trigger 'submit', @$('form').serialize(), @$('[name="agent"]').val(), @$('[name="type"]:checked').val()

    filterDate: ->
      dateFormat = 'DD/MM/YYYY'
      endValue = moment().format dateFormat
      period = @$("select[name='period']").val()

      if period is 'today'
        startValue = endValue
      else if period is 'yesterday'
        startValue = moment().subtract('days', 1).format dateFormat
        endValue = startValue
      else if period is 'this-week'
        startValue = moment().startOf('week').format dateFormat
      else if period is 'last-week'
        startValue = moment().subtract('weeks', 1).startOf('week').format dateFormat
        endValue = moment().subtract('weeks', 1).endOf('week').format dateFormat
      else if period is 'this-month'
        startValue = moment().startOf('month').format dateFormat
      else if period is 'last-month'
        startValue = moment().subtract('months', 1).startOf('month').format dateFormat
        endValue = moment().subtract('months', 1).endOf('month').format dateFormat
      else if period is 'half-year'
        startValue = moment().subtract('months', 6).format dateFormat
      else if period is 'year'
        startValue = moment().subtract('year', 1).format dateFormat

      @$("input[name='createdFrom']").val startValue
      @$("input[name='createdTill']").val endValue

      @$(".date-picker").datepicker('update')