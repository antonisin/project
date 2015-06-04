@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.LidView extends Air.BaseLayout
    template    : 'lid/view/lid'
    _modelBinder: undefined

    behaviors:
      CheckEmail:
        field: 'extraEmail'

    regions:
      extraPhones: '#extraPhones'
      extraEmails: '#extraEmails'
      extraLids  : '#extraLids'

    modelEvents:
      'ready' : 'modelReady'
      'change': 'save'

    events:
      'click .phone_add'    : -> @trigger 'extra:phone:add' if @model.id
      'click .email_add'    : -> @trigger 'extra:email:add' if @model.id
      'click #extra_lid_add': -> @trigger 'extra:lid:add'   if @model.id
      'click #booking-list' : -> @trigger 'bookings:list', @model
      'click #booking-new'  : -> @trigger 'bookings:new' , @model
      'click #booking-close': -> App.vent.trigger 'booking:reject'

      'click #globalCall'   : -> App.vent.trigger 'call:client:action', @model.get('phone')

      'click .fold_button'  : 'fold'

    initialize: ->
      @model.view = @

    onShow: ->
      if @model.id
        @model.trigger 'ready'
        @$('#extra_lid_add, .email_add, .phone_add').removeClass 'disabled'
      else
        @listenTo @model, 'change:id', @modelPersisted, @

      @updateUI()
      @bind()

    bind: ->
      @bindings =
        firstName       : '[name="firstName"]'
        lastName        : '[name="lastName"]'
        sex             : {selector:'[name="sex"]', converter: @sexBinder}
        createdFormatted: '[name="created"]'
        phone           : '[name="phone"]'
        email           : '[name="email"]'
        user            : '[name="userId"]'
        userName        : '[name="userName"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    modelReady: ->
      @$("#booking-list, #booking-new, #booking-close").removeClass 'disabled'

    modelPersisted: (model) ->
      @trigger 'model:persisted', model.id
      @model.trigger 'ready'

    save: ->
      @model.save @model.changedAttributes(),
        wait : true
        patch: true
      if @model.id
        $('#extra_lid_add, .email_add, .phone_add').removeClass('disabled')

    fold: (e) ->
      $btn = $ e.target
      $btn.closest(".fold_area").find(".fold_box").slideToggle()
      $btn.find("i").toggleClass "fa-minus fa-plus"

    sexBinder: (d,v,a,m) ->
      if d is 'ModelToView'
        if v isnt null then _.defer =>
          m.view.$("[name='sex']").closest('button').removeClass 'active'
          m.view.$("[name='sex']").closest('span').removeClass 'SexLabelWomen'
          m.view.$("[name='sex']").closest('span').removeClass 'SexLabelMale'
          m.view.$("[name='sex'][value='#{v}']").closest('button').addClass 'active' , true

          if v == "0" or v == 0
            v = 0
            m.view.$("[name='sex'][value='#{v}']").closest('span').addClass 'SexLabelMale' , true
          if v == "1" or v == 1
            v = 1
            m.view.$("[name='sex'][value='#{v}']").closest('span').addClass 'SexLabelWomen' , true

      if d is 'ViewToModel'
        if v == "0" or v == 0 then v = 0
        if v == "1" or v == 1 then v = 1
      v