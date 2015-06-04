@Air.module 'Accounting.Transfer.New', (New, App, Backbone, Marionette, $, _) ->

  class New.View extends App.BaseItemView
    template: 'accounting/transfer/new/view'
    _modelBinder: undefined

    triggers:
      'click .saveBtn': 'transfer:save'

    onShow: ->
      @initComponents()

    onRender: ->
      @initComponents()

    initComponents: ->
      @updateUI()
      @bind()

      @$('[name="amount"]').inputFilter 'number'

      @initSelect2()

    initSelect2: ->
      @$("[name='agent']").select2
        allowClear: true
        minimumInputLength: 1
        placeholder: "Ид / Имя агента"
        escapeMarkup: (m) -> m
        ajax:
          url: Config.routePrefix + "user/search"
          dataType: 'json'
          data: (q, p) ->
            q: q
          results: (d, p) ->
            results: _.map d, (el) ->
              {id: el.id, text: el.id + " / " + el.firstName + " " + el.lastName}

    bind: ->
      @bindings =
        amount     : '[name="amount"]'
        agent      : '[name="agent"]'
        description: '[name="description"]'

      @_modelBinder = new Backbone.ModelBinder()

      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
