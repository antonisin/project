@Air.module 'Booking.View', (View, App, Backbone, Marionette, $, _) ->

  class View.Layout extends Air.BaseLayout
    template: 'booking/view/layout'
    regions:
      status    : '#status'
      content   : '#content'
      offers    : '#offers'
      newOffer  : '#newOffer'

  class View.StatusView extends Air.BaseItemView
    template: 'booking/view/status'

    modelEvents:
      'change:status' : 'update'

    onShow: ->
      @update()

    update: ->
      status = @model.get 'status'
      @$(".speedbar_item").removeClass 'current active'

      for i in [1..status]
        @$("#item#{i}").addClass 'active'

      @$("#item#{i}").addClass 'current'

  class View.BookingView extends Air.BaseItemView
    template    : 'booking/view/view'
    _modelBinder: undefined

    sendText        : "<i class='fa fa-envelope'></i>"
    sendLoadingText : "<i class='fa fa-spinner fa-spin'></i> Ждите"

    events:
      'click #offer-check'        : -> @trigger 'click:offers:check'
      'click #offer-add'          : 'addOffer'
      'click #offers-send'        : 'sendOffers'
      'click #sale-create'        : ->  App.vent.trigger 'footer:lid:create:sale'
      'change [name="startDate"]' : 'changeDate'
      'change [name="endDate"]'   : 'changeDate'

    modelEvents   :
      'ready'     : 'modelReady'
      'change'    : 'save'

    addOffer: ->
      @trigger 'offer:add', @model
      return

      h= $('#lid').height() + $('#content').find('#content').height()+ 50
      $('body').animate({scrollTop: h }, 200)
      $("#remove").addClass('disabled')

    changeDate: (e) ->
      if e.target.getAttribute('name') is 'startDate'
        picker = @$("[name='endDate']")
        option = 'setStartDate'
      else
        picker = @$("[name='startDate']")
        option = 'setEndDate'

      picker.datepicker option, $(e.target).datepicker 'getDate'
      picker.datepicker 'show' if option is 'setStartDate'

    initialize: ->
      @model.view = @

      @listenTo @, 'offers:sending', => @sending()
      @listenTo @, 'offers:sent', => @sent()

    onShow: ->
      if @model.id
        @model.trigger 'ready'
      else
        @listenTo @model, 'change:id', @modelPersisted, @

      @initComponents()
      @bind()

    modelReady: ->
      @$("#offer-add, #offers-send, #offer-check, #sale-create").removeClass 'disabled'
      App.vent.trigger 'remove:disable:create:sale', @

      @trigger 'ready', @

    modelPersisted: (model) ->
      @trigger 'model:persisted', model
      @model.trigger 'ready'

      @$("#title-new").hide()
      @$("#title-normal").show()

    save: ->
      @model.save() unless @model.isBusy()
      if @model.isValid()
        $("#remove").removeClass('disabled')

    sendOffers: ->
      @trigger 'click:send:offers' if !@$("#offers-send").hasClass 'disabled'
      false

    sending: ->
      @$("#offers-send").addClass('disabled').html @sendLoadingText

    sent: ->
      @$("#offers-send").removeClass('disabled').html @sendText

    initComponents: ->
      @updateUI()
      @initDatePickers()
      @initLocationPickers()

      $("[name='startDelta'], [name='endDelta']").select2
        allowClear: true
        placeholder: "&plusmn;"
        escapeMarkup: (m) -> m
        ajax:
          url: Config.routePrefix + "booking/delta"
          dataType: 'json'
          data: (q, p) ->
            q: q
          results: (d, p) ->
            results: _.map d, (el) ->
              {id: el.id, text: el.name}

      @$("input[type='number']").inputFilter 'number'

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @bindings =
        oid: '[name="oid"]'
        created: {selector: '[name="created"]', converter: @createdBinder}
        adults: '[name="adults"]'
        comment: '[name="comment"]'
        children: '[name="children"]'
        newborns: '[name="newborns"]'
        routeType: {selector: '[name="routeType"]', converter: @routeTypeBinder}
        isBusiness: {selector: '[name="isBusiness"]', converter: @routeClassBinder}
        isEconom: {selector: '[name="isEconom"]', converter: @routeClassBinder}

        startDate: {selector: '[name="startDate"]', converter: @dateBinder}
        endDate: {selector: '[name="endDate"]', converter: @dateBinder}

        startDelta: {selector: '[name="startDelta"]', converter: @deltaBinder}
        endDelta: {selector: '[name="endDelta"]', converter: @deltaBinder}

        startLocation: {selector: '[name="startLocation"]', converter: @locationBinder}
        endLocation: {selector: '[name="endLocation"]', converter: @locationBinder}

      @_modelBinder.bind @model, @el, @bindings

      @$(".date-picker").datepicker('update')

    routeTypeBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        m.view.$("[name='routeType'][value='#{parseInt(v)}']").prop 'checked', true
        $.uniform.update("[name='routeType']")
      v

    routeClassBinder: (d, v, a, m) ->
      group = m.view.$("[name='#{a}']").closest '.passengers'
      if d is 'ModelToView'
        if v == 1 or v is true
          group.find("[name='#{a}']").prop 'checked', true

      $.uniform.update group.find('input')
      v

    createdBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        moment(v.date).format App.request 'constants:get', 'dateFormat'

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
          name = Lang.get 'booking.unknown_location'
      else
        code = $el.find("[id*='#{a}'] .select2-chosen").html().substr 0, 3
        name = $el.find("[id*='#{a}'] .select2-chosen small").html()

        model = {id: v, code: code, name: name}
        m.attributes["#{a}Model"] = model

      unless v is ''
        $el.find("input[name='#{a}']").attr 'data-code', code
        $el.find("input[name='#{a}']").attr 'data-name', name
        $el.find("[id*='#{a}']").select2 "val", v
      $el.find('.city').html name
      v

    deltaBinder: (d, v, a, m) ->
      $el = m.view.$("[name='#{a}']").closest('.form-group')
      model = m.get("#{a}Model")

      if d is 'ModelToView'
        name = if model then model.name else '0'
      else
        name = $el.find("[id*='#{a}'] .select2-chosen").html()
        model = {id: v, name: name}
        m.attributes["#{a}Model"] = model

      $el.find("[id*='#{a}'] .select2-chosen").html name
      v
