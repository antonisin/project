@Air.module 'Sale.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends Air.BaseLayout
    template: 'sale/edit/layout'
    queue: []
    regions:
      payment     : '#payment'
      flights     : '#flights'
      passangers  : '#passangers'
      instruction : '#instruction'

    className: 'form_wrap gray_wrap'

    templateHelpers : ->
      consolidators : window.data.consolidators
      rates         : window.data.rates
      paymenttypes  : window.data.paymenttypes

    events:
      'click #manual'         : ->  @$("#import-area").slideToggle 200
      'click #import'         : 'clickImport'
      'click #passenger-list' : 'passangersList'
      'click #send'           : -> @trigger 'click:send'
      
    modelEvents   :
      'change'    : 'save'

    initialize: ->
      App.execute 'scroll:page:top'
      @listenToOnce @model, 'sync', @saved unless @model.id
      @listenToOnce @model, 'disable', @disable

    saved: ->
      @$("#send").removeClass 'disabled'

    save: ->
      @model.save() unless @model.isBusy()
          
    addToQueue: (cb) ->
      if @model.isBusy() or @model.id is undefined
        @listenToOnce @model, 'sync', => cb()
      else
        cb()

    onShow: ->
      @initComponents()
      @disable if @model.get 'isSent'

    initComponents: ->
      @updateUI()
      @updateUniform()
      @bind()

    disable: ->
      @$("#sale input, #sale textarea, #sale select").prop 'disabled', true
      @$("#send, #import, #manual").addClass 'disabled'

    passangersList: ->
      @$(".passenger-row").slideToggle 200
      @$("#passenger-list").find("i").toggleClass("fa-chevron-up fa-chevron-down");

    bind: ->
      @model.view = @

      bindings =
        code        : '[name="code"]'
        consolidator: '[name="consolidator"]'
        validator   : '[name="validator"]'
        paymentType : '[name="paymentType"]'
        rate        : {selector: '[name="rate"]', converter: @rateBinder}
        income      : '[name="income"]'
        fee         : '[name="fee"]'
        oneTransaction: {selector: '[name="oneTransaction"]', converter: @oneTransactionBinder}
        hideRoute   : {selector: '[name="hideRoute"]', converter: @hideRouteBinder }
        showComment : {selector: '[name="showComment"]', converter: @showCommentBinder }
        hidePersonalData : {selector: '[name="hidePersonalData"]', converter: @hidePersonalDataBinder }
        comment     : '[name="comment"]'

        totalMarkup   : '[name="totalMarkup"]'
        totalFee      : '[name="totalFee"]'
        totalTax      : '[name="totalTax"]'
        totalAcquiring: '[name="totalAcquiring"]'

      @_modelBinder = new Backbone.ModelBinder()      
      @_modelBinder.bind @model, @el, bindings

    clickImport:->
      @addToQueue (=> @trigger 'import')

    rateBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        m.view.$("#fee").prop "disabled", parseInt(v) is 2
      v

    oneTransactionBinder: (d, v, a, m) -> 
      if d is 'ModelToView'
        if v is true then v = 1
        if v is false then v = 0
        m.view.$("[name='oneTransaction'][value='#{parseInt(v)}']").prop 'checked', true
        $.uniform.update("[name='oneTransaction']")
      v

    hideRouteBinder: (d, v, a, m) -> 
      if d is 'ModelToView'
        if v == 1 or v is true
          m.view.$("[name='hideRoute']").prop 'checked', true           
      $.uniform.update("[name='hideRoute']")
      v

    showCommentBinder: (d, v, a, m) -> 
      if d is 'ModelToView'
        if v == 1 or v is true
          m.view.$("[name='showComment']").prop 'checked', true           
      $.uniform.update("[name='showComment']")
      v

    hidePersonalDataBinder: (d, v, a, m) -> 
      if d is 'ModelToView'
        if v == 1 or v is true
          m.view.$("[name='hidePersonalData']").prop 'checked', true           
      $.uniform.update("[name='hidePersonalData']")
      v

