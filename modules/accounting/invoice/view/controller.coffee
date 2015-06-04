@Air.module 'Accounting.Invoice.View', (View, App, Backbone, Marionette, $, _) ->

  class View.BaseController extends App.Base.Controller
    updateModel: ->
      scheme = App.request 'scheme:entity', @model.get('scheme')

      @productivity = @model.get('income') /  @model.get('lids')
      @efectivity = @model.get('salesCount') / @model.get('lids') * 100
      @resetDates scheme

    resetDates: (scheme) ->
      _.filter(scheme.get('conversions'), @getConversion)
      if !@conversion then @conversion = 0
      @model.set('conversion', scheme.get('conversions')[@conversion])

      _.filter(scheme.get('GPLid'), @getGPlid)
      if !@GPLid then @GPLid = 0

      @bonus = null;
      scheme.get('bonus')['GP'].forEach @setBonus
      if @bonus != null then @bonus = scheme.get('bonus')['bonus'][@bonus] else @bonus = 0
      @model.set('bonus', @bonus)

      @getPercents scheme

    getConversion: (item, index) =>
      if @efectivity >= item
        @conversion = index

    getGPlid: (item, index) =>
      if @productivity >= item
        @GPLid =  index

    getPercents: (scheme) ->
      index = Math.floor(@GPLid/2) * scheme.get('conversions').length + @conversion
      @model.set('percent', scheme.get('percents')[index])

    setBonus: (item, index, b, c) =>
      if @model.get('income') >= item
        @bonus = index


  class View.Controller extends View.BaseController
    initialize: (opts) ->
      { id, @model, @region } = opts

      @model or= App.request 'invoice:entity', id

      @layout = @getLayout()

      @listenTo @layout, 'show', =>
        @updateModel()
        @showDetails()
        @showSaleFines()
        @showDisciplinaryFines()
        @showSale()
        @showScheme()

      @show @layout,
        loading:
          entities: @model

    getLayout: ->
      view = new View.Layout
        model: @model

      @listenTo view, 'details:scheme:change', (e) ->
        @model.set('scheme', parseInt(e.target.value))
        @updateModel()
        @model.save @model.attributes

        @layout.sales.close()
        @layout.scheme.close()

        @showSale()
        @showScheme()

      @listenTo view, 'invoice:confirm:action', =>
        @model.set 'isConfirmed', true
        @model.save()
        @layout.enableControls()

      @listenTo view, 'invoice:reject:action', =>
        @model.set 'isRejected', true
        @model.save()
        @layout.enableControls()

      @listenTo view, 'invoice:download:action',   -> @sendData 'download'
      @listenTo view, 'invoice:send:email:action', -> @sendData 'send'

      view

    showDetails: ->
      @layout.details.show new View.DetailsItemView
        model: @model

    showSaleFines: ->
      if @model.get 'isConfirmed' or @model.get 'isRejected' then disabled = true
      new View.SaleFine.Controller
        disabled: disabled
        JSON    : @model.get 'saleFines'
        region  : @layout.saleFines

    showDisciplinaryFines: ->
      if @model.get 'isConfirmed' or @model.get 'isRejected' then disabled = true
      new View.DisciplinaryFine.Controller
        disabled: disabled
        JSON    : @model.get 'disciplinaryFines'
        region  : @layout.disciplinaryFines

    showSale: ->
      new View.Sale.Controller
        region: @layout.sales
        model : @model
        collection: @model.get 'sales'

    showScheme: ->
      @layout.scheme.show new Air.Accounting.Scheme.Preview.ItemView
        model: App.request 'scheme:entity', @model.get('scheme')
        invoicePercent: @model
        templateHelpers: =>
          invoicePercent : @model.get('percent')
          invoiceBonus: @model.get('bonus')

    sendData: (action) ->
      xhr = new XMLHttpRequest()
      xhr.onreadystatechange = @enableControls
      xhr.open("POST", Config.routePrefix + "invoice/" + action + '/' + @model.id, true)
      xhr.send()

    enableControls:(e) =>
      if e.target.status == 200
        @layout.enableControls()
