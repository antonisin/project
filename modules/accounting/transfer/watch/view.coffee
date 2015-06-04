@Air.module 'Accounting.Transfer.Watch', (Watch, App, Backbone, Marionette, $, _) ->

  class Watch.View extends App.BaseItemView
    template: 'accounting/transfer/watch/view'
    _modelBinder: undefined

    events:
      'change [name="period"]': 'filterDate'

    dialog: ->
      title: 'Следить за всеми переводами'

    onShow: ->
      @initComponents()

    initComponents: ->
      @bind()
      @initDatePickers startDate: null
      @updateUI()

    bind: ->
      @bindings =
        start: '[name="start"]'
        end  : '[name="end"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    filterDate: ->
      dateFormat = 'DD/MM/YYYY'
      startValue = moment().format dateFormat
      period = @$("select[name='period']").val()


      switch
        when period is 'one-day'
          endValue = moment().add('days', 1).format dateFormat
        when period is 'two-days'
          endValue = moment().add('days', 2).format dateFormat
        when period is 'three-days'
          endValue = moment().add('days', 3).format dateFormat
        when period is 'week'
          endValue = moment().add('weeks', 1).format dateFormat
        when period is 'month'
          endValue = moment().add('months', 1).format dateFormat
        when period is 'always'
          endValue = moment().add('years', 59).format dateFormat

      @$('[name="start"]').val startValue
      @$('[name="end"]').val endValue

      @$(".date-picker").datepicker('update')
