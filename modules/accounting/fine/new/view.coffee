@Air.module 'Accounting.Fine.New', (New, App, Backbone, Marionette, $, _) ->

  class New.FormView extends App.BaseItemView
    template: 'accounting/fine/new/form'
    className: 'newFine'
    _modelBinder: undefined

    initialize: ->
      @listenTo @options.selectHelper, 'sync', -> @render()

      @template = 'accounting/fine/new/form_disciplinary' if @model.getType() is 'disciplinary'
      @templateHelpers =
        selectHelper: @options.selectHelper

    events:
      'click .closeBtn': 'reset'
      'click .saveBtn' : -> @trigger 'new:fine:save'
      'change [name="reason"]': 'setPoint'

    onShow: ->
      @initComponents()

    onRender: ->
      @initComponents()

    setPoint: ->
      reason = @$('[name="reason"] option:selected').attr('data')
      @$('[name="points"]').val @$('[name="reason"] option:selected').attr('data')
      @model.set 'points', reason

    initComponents: ->
      @updateUI()
      @bind()
      #filters for disciplinary fines
      @$('[name="lid"], [name="points"]').inputFilter 'number'

      #fliltes for HX/ADM
      @$('[name="pnr"]').inputFilter 'text'
      @$('[name="day"]').inputFilter 'date'
      @$('[name="value"]').inputFilter 'number'
      @initDatePickers startDate: null
      @initSelect2()

    initSelect2: ->
      @$("[name='lid']").select2
        allowClear: true
        minimumInputLength: 1
        placeholder: "Ид / Имя агента"
        escapeMarkup: (m) -> m
        ajax:
          url: Config.routePrefix + "lid/search"
          dataType: 'json'
          data: (q, p) ->
            q: q
          results: (d, p) ->
            results: _.map d, (el) ->
              {id: el.id, text: el.id + " / " + el.firstName + " " + el.lastName}

    reset: ->
      @$(':input:not(:button):not(:checkbox):not(:submit)').val ''
      @$('.date-picker').datepicker 'update'

    bind: ->
      if @model.getType() is 'sale'
        @bindings =
          day    : {selector: '[name="day"]', converter: @dateBinder}
          pnr    : '[name="pnr"]'
          status : '[name="status"]'
          value  : '[name="value"]'
      else
        @bindings =
          lid    : '[name="lid"]'
          points : '[name="points"]'
          reason : '[name="reason"]'

      @_modelBinder = new Backbone.ModelBinder()

      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

  class New.InstructionView extends App.BaseItemView
    template: 'accounting/fine/new/instruction'
