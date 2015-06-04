@Air.module 'Accounting.Transfer.Assign', (Assign, App, Backbone, Marionette, $, _) ->

  class Assign.View extends App.BaseItemView
    template: 'accounting/transfer/assign/view'
    _modelBinder: undefined

    dialog: ->
      title: 'Присвоить перевод'

    onShow: ->
      @initComponents()

    onRender: ->
      @initComponents()

    initComponents: ->
      @updateUI()
      @bind()

      @$('[name="sale"]').inputFilter 'number'

      @initSelect2()

    initSelect2: ->
      @$("[name='sale']").select2
        allowClear: true
        minimumInputLength: 1
        placeholder: "Номер продажи"
        escapeMarkup: (m) -> m
        ajax:
          url: Config.routePrefix + "sale/search"
          dataType: 'json'
          data: (q, p) ->
            q: q
          results: (d, p) ->
            results: _.map d, (el) ->
              {id: el.id, text: el.id + " / " + el.route}

    bind: ->
      @bindings =
        sale   : '[name="sale"]'
        comment: '[name="comment"]'

      @_modelBinder = new Backbone.ModelBinder()

      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
