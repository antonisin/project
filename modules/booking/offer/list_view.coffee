@Air.module 'Booking.Offer', (Offer, App, Backbone, Marionette, $, _) ->
  class Offer.ItemView extends Air.BaseItemView
    template            : 'booking/offer/item'
    className           : 'pos_relative table_extend note'
    _modelBinder        : undefined

    events:
      'click #minimize'  : 'minimize'
      'click #maximize'  : 'maximize'
      'click #remove'    : -> @trigger 'item:delete', @model
      'click #selects'   : -> @trigger 'select', @model
      'click #properties': 'showProperties'
      'click .close'     : 'hideError'
      'change input[type="text"]:not(".input-sm")' : 'checkPrice'
      'change [name="label"]'     : 'setLabel'

      'click #selected': (e) ->
        if @$("#selected").prop('checked') is false then @$("#selected").prop('checked', true) else @$("#selected").prop('checked', false)

      'click #force-true': ->
        @model.set 'force', 'true'
        App.vent.trigger 'booking:offers:add:force'

      'click #force-false': ->
        @$(".alert-warning").hide()

      'click .colors .cell': (e) ->
        @$("[name='labelColor']").val($(e.target).attr('id')).trigger('change') unless @$("[name='code']").prop 'disabled'

      'change [id="commentCB"]': (e) ->
        @$("[id='customCommentCB']").prop 'disabled', not $(e.target).prop('checked')

      'click input.form-control.input-sm' : (e) -> return false;

    modelEvents:
      'request' : -> @$(".alert-danger").hide()
      'change'  : ->
        if @model.id
          Backbone.Validation.unbind @
          Backbone.Validation.bind @
          @model.save @model.attributes,
            wait: true

    checkPrice: (e) ->
      pattern = /^[1-9]\d*[\.,]?\d*$/g

      if !pattern.test $(e.target).val()
        $(e.target).addClass 'has-error'
        App.execute 'notify:error', App.request('lang:get', 'booking:add:offer:wrong:price')
      else
        $(e.target).removeClass 'has-error'

    templateHelpers: ->
      labels  : App.request 'offerlabels:entities'
      comments: App.request 'offercomments:entities'
      colors  : App.request 'offercolors:entities'

    initialize: (opts) ->
      @labels       = opts.labels
      @comments     = opts.comments
      @bookingModel = opts.bookingModel
      @model.view   = @

      @listenTo @bookingModel, 'change', =>
        if not @model.get('isSent')
          @model.trigger 'update:validation' , @bookingModel if @model.id
          @bookingChange @bookingModel

      @listenTo @model, 'sent', @disable
      @listenTo @, 'highlight', @highlight
      @listenTo @, 'select', @select
      @listenTo @, 'save:error', @showErrors
      @listenTo @, 'save:warning', @showWarnings
      @listenTo @, 'update:validation', =>
        @$("input, textarea, .form-group").removeClass 'has-error'
        Backbone.Validation.unbind @
        Backbone.Validation.bind @

    onRender: ->
      if !@model.get('isSent')
        @model.trigger 'update:validation' , @bookingModel if @model.id
        @bookingChange @bookingModel

    onShow: ->
      @disable() if @model.get('isSent')
      @block() if @model.id
      @initComponents()
      @labelSelect()
      @bind()

    disable: ->
      @$("input[id!='selected'], textarea").prop 'disabled', true
      @$("#remove").addClass 'disabled'
      @$el.removeClass('note-success').addClass 'note-warning'

    block: ->
      @$("textarea").prop 'disabled', true

    bind: ->
      @bindings =
        order           : {selector: '[name="order"]', converter: @orderConverter}
        adultNet        : '[name="adultNet"]'
        adultSale       : '[name="adultSale"]'
        childNet        : '[name="childNet"]'
        childSale       : '[name="childSale"]'
        newbornNet      : '[name="newbornNet"]'
        newbornSale     : '[name="newbornSale"]'
        code            : '[name="code"]'
        createdFormatted: '[name="createdFormatted"]'
        comments        : {selector: '[name="comment"]', converter: @commentsBinder, silentModelToView: true}
        total           : '[name="total"]'
        markUp          : '[name="markUp"]'
        labelColor      : {selector: '[name="labelColor"]', converter: @colorBinder}
        customLabel     : '[name="customLabel"]'
        customComment   : '[name="customComment"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    initComponents: ->
      @updateUI()
      @$("input[data-filter='number']").inputFilter 'number'

    highlight: ->
      @$el.effect 'highlight', {color: '#5bc0de'}, 500

    minimize: ->
      @$('.offers_form, #minimize').hide()
      @$('#maximize').show()

    maximize: ->
      @$('.offers_form, #minimize').show()
      @$('#maximize').hide()

    hideError: ->
      @$('.offer-errors').fadeOut()

    bookingChange: (bookingModel) ->
      if bookingModel.get('adults') > 0
        @$("input[name='adultNet'], input[name='adultSale']").prop 'disabled', false
      else
        @$("input[name='adultNet'], input[name='adultSale']").prop 'disabled', true
        @$("input[name='adultNet'], input[name='adultSale']").removeClass 'has-error'

      if bookingModel.get('children') > 0
        @$("input[name='childNet'], input[name='childSale']").prop 'disabled', false
      else
        @$("input[name='childNet'], input[name='childSale']").prop 'disabled', true
        @$("input[name='childNet'], input[name='childSale']").removeClass 'has-error'

      if bookingModel.get('newborns') > 0
        @$("input[name='newbornNet'], input[name='newbornSale']").prop 'disabled', false
      else
        @$("input[name='newbornNet'], input[name='newbornSale']").prop 'disabled', true
        @$("input[name='newbornNet'], input[name='newbornSale']").removeClass 'has-error'

    select: (force = null) ->
      unless @model.id
        if force is true
          @trigger 'error:not:saved', 'info', 'offer:select:not:saved:multi'
        else
          @trigger 'error:not:saved', 'error', 'offer:select:not:saved'
        @$("#selected").prop 'checked', false
        @updateUniform()
        return false

      if force is false or force isnt true and @$("#selected").prop('checked') is true
        @$("#selected").prop 'checked', false
        @$el.removeClass 'note-success'
        @model.unchoose()
      else
        @$("#selected").prop 'checked', true
        @$el.addClass 'note-success'
        @model.set('isSent', true)
        @model.choose()
      @updateUniform()

    showErrors: (errors) ->
      console.log errors

    showWarnings: (warnings) ->
      @formatHTML = "<ul>";

      if warnings.foodType
        @prepareArray warnings.foodType

      if warnings.location
        @prepareArray warnings.location

      if warnings.airline
        @prepareArray warnings.airline

      @formatHTML = @formatHTML + "</ul>";

      @$el.find('.alert-warning p').empty().append(@formatHTML).closest('div').fadeIn 200

    prepareArray: (array) ->
      array.forEach (item) =>
       @formatHTML = @formatHTML  + '<li>' + item.message + ': ' + item.value + '</li>'

    ### binders ###
    orderConverter: (d, v, a, m) ->
      if d is 'ModelToView'
        if m.collection then "##{m.collection.indexOf(m) + 1}" else 'Новое предложение'

    labelSelect: ->
      @listenTo App.vent, 'booking:offers:added', ->
        @labelCheck parseInt(@model.get('label'))
      @listenTo App.vent, 'booking:offers:sent', ->
        @labelCheck parseInt(@model.get('label'))
      @listenTo @, 'highlight', ->
        @labelCheck parseInt(@model.get('label'))
      @labelCheck parseInt(@model.get('label'))

    labelCheck:(v) ->
      @$el.find("[name='label'][value='" + v + "']").closest('span').addClass('checked')
      if v == 0 and !@model.get('isSent') then @$el.find("[name='customLabel']").attr('disabled', false)
      else @$el.find("[name='customLabel']").attr('disabled', true)

    setLabel: (e) ->
      @model.set('label', parseInt(e.target.value))
      @labelCheck parseInt(e.target.value)

    commentsBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        m.view._modelBinder.unbind()
        data = if v and v.length > 0 then JSON.parse v else []
        for item in data
          m.view.$("[name='comment'][value='#{parseInt(item)}']").prop 'checked', true
        m.view._modelBinder.bind m, m.view.el, m.view.bindings, {silent: true}
        $.uniform.update("[name='comment']")
      else if d is 'ViewToModel'
        data = []
        $.each m.view.$("[name='comment']:checked"), ->
          data.push $(@).val()
        JSON.stringify data

    colorBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        cell = m.view.$(".colors ##{v}")

        m.view.$('.colors .cell').css 'boxShadow', ''
        cell.css 'boxShadow', "0px 0px 7px 2px #{cell.css 'backgroundColor'}"
      v

  class Offer.EmptyView extends Air.BaseItemView
    template            : 'booking/offer/empty'

  class Offer.ListView extends Air.BaseCollectionView
    itemView            : Offer.ItemView
    itemViewContainer   : '#items'
    emptyView           : Offer.EmptyView
    className           : 'offers-list-stripped'
    renderOrder         : 'DESC'

    initialize: ->
      @listenTo @, 'highlight', @highlight
      @listenTo @, 'check', @select
      @listenTo @collection, 'destroy', @elRemoved
      super

    highlight: (model) ->
      view = @children.findByModel model
      view.trigger 'highlight' if view

    select: ->
      @children.call 'trigger', 'select', @collection.getChosen().length < @collection.size()

    elRemoved: ->
      @children.call 'trigger', 'bind'