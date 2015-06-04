@Air.module 'Sale.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.PaymentPassangerItemView extends Air.BaseItemView
    template: 'sale/edit/payment_passanger'
    className: 'pnr_val clearfix'
    _modelBinder  : undefined

    events:
      'click .confirm': 'confirm'

    templateHelpers : ->
      countries : window.data.countries
      orderFee  : App.request 'settings:get', 'sale_fee'

    initialize: ->
      @listenToOnce @, 'disable', -> @disable()

    onShow: ->
      @initDatePickers startDate: null
      @bind()
      @initComponents()
      @disable() unless @model.get('isConfirmed') is 0

    initComponents: ->
      @initTimeEntry()
      @updateUI()

    disable: ->
      @$('.date-picker *').unbind()
      @$("input, select").prop 'disabled', true
      @$('.panel-warning').toggleClass 'panel-warning panel-success'
      @$(".SexBtn").addClass 'disabled'
      @$(".confirm").addClass 'disabled'

    confirm: ->
      unless @model.isBusy()
        @model.set 'isConfirmed', 1
        @model.save()
        @disable()
        @enablePayment()

    enablePayment: ->
      if $('.confirm.disabled').length == @model.collection.length
        $(".pay").removeAttr 'disabled'

    bind: ->
      @$('.maxDate').datepicker('setEndDate', new Date())
      @$('.maxDate').datepicker('update', new Date(1990, 0, 1))
      @$('.minDate').datepicker('setStartDate', "+1d")

      @model.view = @
      @_modelBinder = new Backbone.ModelBinder()
      @bindings =
        firstName : '[name="firstName"]'
        lastName  : '[name="lastName"]'
        country   : '[name="country"]'
        passportNumber : '[name="passportNumber"]'
        order     : {selector: '[name="order"]', converter: @orderBinder}
        birthday  : {selector: '[name="birthday"]', converter: @dateBinder}
        sex       : {selector: '[name="sex"]', converter: @sexBinder}
        passportExpiration  : {selector: '[name="passportExpiration"]', converter: @dateBinder}
        firstName : '[name="firstName"]'
        lastName  : '[name="lastName"]'
        country   : '[name="country"]'
        passportNumber : '[name="passportNumber"]'
        order     : {selector: '[name="order"]', converter: @orderBinder}
        birthday  : {selector: '[name="birthday"]', converter: @dateBinder}
        sex       : {selector: '[name="sex"]', converter: @sexBinder}
        passportExpiration  : {selector: '[name="passportExpiration"]', converter: @dateBinder}

      @_modelBinder.bind @model, @el, @bindings

    dateBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        moment(v).format App.request 'constants:get', 'dateFormat'
      v

    orderBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        m.collection.indexOf(m) + 1

    sexBinder: (d,v,a,m) ->
      if d is 'ModelToView'
       _.defer =>
          m.view.$("[name='sex']").closest('button').removeClass 'active'
          m.view.$("[name='sex']").closest('span').removeClass 'SexLabelWomen'
          m.view.$("[name='sex']").closest('span').removeClass 'SexLabelMale'
          m.view.$("[name='sex'][value='#{v}']").closest('button').addClass 'active' , true
          if v == "0" or v == 0
            m.view.$("[name='sex'][value='#{v}']").closest('span').addClass 'SexLabelMale' , true
          if v == "1" or v == 1
            m.view.$("[name='sex'][value='#{v}']").closest('span').addClass 'SexLabelWomen' , true
      v

  class Edit.PaymentPassangerListView extends Air.BaseCompositeView
    template: 'sale/edit/payment_passangers'
    itemView: Edit.PaymentPassangerItemView
    itemViewContainer: '#passangers'

    initialize: (opts) ->
      { @payment } = opts

      @listenToOnce @, 'passengers:confirmed', =>
        @disable()

    onShow: ->
      if @collection.where(isConfirmed: 0).length is 0
        @$('.confirmAll').addClass('disabled')

    templateHelpers: ->
      payment: @payment

    triggers:
      'click .confirmAll': 'passengers:confirm:all'

    events:
      'click .pay': 'save'

    save: ->
      @payment.set 'isPaid', true
      @payment.save()
      @$('.pay').prop 'disabled', true

    disable: ->
      @$(".confirmAll").addClass 'disabled'
      @$(".pay").removeAttr 'disabled'
      @children.call 'trigger', 'disable'

  class Edit.InstructionInitialItemView extends Air.BaseItemView
    template       : 'sale/edit/initial'
    _modelBinder   : undefined

  class Edit.InstructionInfoItemView extends Air.BaseItemView
    template       :'sale/edit/info'
    _modelBinder: undefined

    events:
      'click .close'  : 'showInstructions'

    showInstructions: ->
     @$('.alert').fadeOut '1000' , =>
       @trigger 'show:instructions'

    initialize: (opts) ->
      @warnings = opts?.warnings

    onShow: ->
      @temp = "<ul>";

      if @warnings.time
        @formatHTML @warnings.time

      if @warnings.location
        @formatHTML @warnings.location

      if @warnings.airline
        @formatHTML @warnings.airline

      @temp = @temp + "</ul>";

      @$el.find('p').after @temp

    formatHTML: (array) =>
      array.forEach (element) =>
        @temp = @temp + "<li>" + element.message + ": <u>" + element.value + "</u></li>"

  class Edit.InstructionSuccessItemView extends Air.BaseItemView
    template      : 'sale/edit/success'
    _modelBinder  : undefined

    events:
      'click .close' : 'showInstructions'

    showInstructions: ->
      @$('.alert').fadeOut '1000' , =>
        @trigger 'show:instructions'

  class Edit.InstructionErrorItemView extends Air.BaseItemView
    template      : 'sale/edit/error'
    _modelBinder  : undefined

    events:
      'click .close' : 'showInstructions'
      'click #remove-spaces' : 'removeSpaces'

    showInstructions: ->
      @$('.alert').fadeOut '1000' , =>
        @trigger 'show:instructions'

    removeSpaces: ->
     code = $('[name="code"]')
     textarea = code.val('')
     @trigger 'update:code'

    initialize: (opts) ->
      @errors     = opts.errors.errors.errors
      @flights    = opts.errors.errors.flights
      @passangers = opts.errors.errors.passangers

    onShow:->
      msgTag = $("#msg")
      temp = ""

      if @errors and @errors.length >0
          temp = temp + "<ul>"
          for item in @errors
            temp = temp + "<li>" + item + "</li>"
          temp = temp + "</ul>"

      if @flights and @flights.length > 0
        temp = temp + "<ul><li>Перелёты</li>"
        if @flights.length > 0
          temp = temp + "<ul>"
          for item in @flights
            temp = temp + "<li>" + item + "</li>"
          temp = temp + "</ul>"
        temp = temp + "</ul>"

      if @passangers and @passangers.length>0
        temp = temp + "<ul><li>Пасажиры</li>"
        if @passangers.length > 0
          temp = temp + "<ul>"
          for item in @passangers
            temp = temp + "<li>" + item + "</li>"
          temp = temp + "</ul>"
        temp = temp + "</ul>"

      msgTag.append temp

  class Edit.PassangerItemView extends Air.BaseItemView
    template      : 'sale/edit/passanger'
    className     : 'pnr_val clearfix pnr_val_with_border'
    _modelBinder  : undefined

    modelEvents   :
      'change'    : 'save'

    templateHelpers : ->
      countries : window.data.countries
      orderFee  : App.request 'settings:get', 'sale_fee'

    initialize: ->
      @listenToOnce @, 'disable', @disable

    onShow: ->
      @initDatePickers startDate: null
      @bind()
      @initComponents()

    initComponents: ->
      @initTimeEntry()
      @updateUI()

    disable: ->
      @$('.date-picker *').unbind()
      @$("input, select").prop 'disabled', true
      @$(".SexBtn").addClass 'disabled'

    save: ->
      unless @model.isBusy()
        @model.save @model.attributes,
          success: => @trigger 'passanger:change'

    bind: ->
      @$('.maxDate').datepicker('setEndDate', new Date())
      @$('.maxDate').datepicker('update', new Date(1990, 0, 1))
      @$('.minDate').datepicker('setStartDate', "+1d")

      @model.view = @
      @_modelBinder = new Backbone.ModelBinder()
      @bindings =
        firstName : '[name="firstName"]'
        lastName  : '[name="lastName"]'
        country   : '[name="country"]'
        total     : '[name="total"]'
        net       : '[name="net"]'
        fee       : '[name="fee"]'
        markup    : '[name="markup"]'
        passportNumber : '[name="passportNumber"]'
        order     : {selector: '[name="order"]', converter: @orderBinder}
        birthday  : {selector: '[name="birthday"]', converter: @dateBinder}
        sex       : {selector: '[name="sex"]', converter: @sexBinder}
        passportExpiration  : {selector: '[name="passportExpiration"]', converter: @dateBinder}

      @_modelBinder.bind @model, @el, @bindings

    dateBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        moment(v).format App.request 'constants:get', 'dateFormat'
      v

    orderBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        m.collection.indexOf(m) + 1

    sexBinder: (d,v,a,m) ->
      if d is 'ModelToView'
       _.defer =>
          m.view.$("[name='sex']").closest('button').removeClass 'active'
          m.view.$("[name='sex']").closest('span').removeClass 'SexLabelWomen'
          m.view.$("[name='sex']").closest('span').removeClass 'SexLabelMale'
          m.view.$("[name='sex'][value='#{v}']").closest('button').addClass 'active' , true
          if v == "0" or v == 0
            m.view.$("[name='sex'][value='#{v}']").closest('span').addClass 'SexLabelMale' , true
          if v == "1" or v == 1
            m.view.$("[name='sex'][value='#{v}']").closest('span').addClass 'SexLabelWomen' , true
      v

  class Edit.PassangerCollectionView extends Air.BaseCollectionView
    itemView    : Edit.PassangerItemView

    initialize: ->
      @listenToOnce @collection, 'disable', =>  @children.call 'trigger', 'disable'


  class Edit.FlightItemView extends Air.BaseItemView
    template    : 'sale/edit/flight_item'
    className   : 'item-set'
    _modelBinder  : undefined

    modelEvents   :
      'change'    : 'save'

    events              :
      'click #delete'   : (e) ->
        e.stopImmediatePropagation()
        @trigger 'click:delete', @model
      'change [name="startDate"]' : 'updateDate'

    initialize: ->
      @listenToOnce @, 'disable', @disable

    onShow: ->
      @initComponents()
      @bind()

    onDomRefresh: ->
      @initComponents()

    initComponents: ->
      @initDatePickers startDate: null
      @initTimeEntry()
      @initLocationPickers()
      @initAirlinePickers()
      @updateUI()

    disable: ->
      @$('.date-picker *').unbind()
      @$("input").prop 'disabled', true
      @$("#delete").addClass 'disabled'

    save: ->
      if $(event.target).closest(".form-group").prev().find("input").val() != ""
        @model.save() unless @model.isBusy()

    bind: ->
      @model.view = @
      @_modelBinder = new Backbone.ModelBinder()
      @bindings =
        startTime       : '[name="startTime"]'
        endTime         : '[name="endTime"]'
        airline         : '[name="airline"]'
        name            : '[name="name"]'
        reservationCode : '[name="reservationCode"]'
        startDate       : {selector: '[name="startDate"]', converter: @dateBinder}
        endDate         : {selector: '[name="endDate"]', converter: @dateBinder}
        startLocation   : {selector: '[name="startLocation"]', converter: @locationBinder}
        endLocation     : {selector: '[name="endLocation"]', converter: @locationBinder}
        airline         : {selector: '[name="airline"]', converter: @locationBinder}

      @_modelBinder.bind @model, @el, @bindings
      @$('.endD').datepicker 'setStartDate', $(".startD").datepicker("getDate")
      @$('.date-picker').datepicker 'update'

    updateDate: ->
      @$('.endD').datepicker 'setStartDate', $('.startD').datepicker('getDate')
      @$('.date-picker').datepicker 'update'

    dateBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        moment(v).format App.request 'constants:get', 'dateFormat'
      v

    locationBinder: (d, v, a, m) ->
      $el = m.view.$("[name='#{a}']").closest('.form-group')
      model = m.get("#{a}Model")

      if d is 'ModelToView'
        if model
          code = model.code
          name = model.name
        else
          code = ''
          name = ''
      else
        code = $el.find("[id*='#{a}'] .select2-chosen").html().substr 0, 3
        name = $el.find("[id*='#{a}'] .select2-chosen small").html()

        model = {id: v, code: code, name: name}
        m.attributes["#{a}Model"] = model

      unless v is ''
        $el.find("input[name='#{a}']").attr 'data-code', code
        $el.find("[id*='#{a}']").select2 "val", v
      v

  class Edit.FlightCompositeView extends Air.BaseCompositeView
    template    : 'sale/edit/flight_layout'
    itemView    : Edit.FlightItemView
    itemViewContainer: '#items'
    className   : 'pnr_val clearfix pnr_val_with_border_grey'

    events      :
      'click #add-flight'   : (e) ->
        e.stopImmediatePropagation()
        @trigger 'new:flight'

    templateHelpers: ->
      reservationCode: @model.get 'reservationCode'

    bindings:
      reservationCode : '[name="reservationCode"]'

    initialize: ->
      @listenToOnce @collection, 'disable', @disable
      @listenToOnce @, 'enable', @enable

    onShow:->
      @updateUI()
      @enable() if @model.id

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings

    disable: ->
      @$("input").prop 'disabled', true
      @$("#add-flight").addClass 'disabled'
      @children.call 'trigger', 'disable'

    enable: ->
      @$("#add-flight").removeClass 'disabled'
