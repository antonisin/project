@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ExtraPhoneItem extends Air.BaseItemView
    template: 'lid/extra/phone'
    tagname :  'div'
    modelEvents: 
      'change' : 'saveModel'
    events:
      'click .phone_remove' :'modelDestroy'
      'click #extraPhoneCallGlobal'  : -> App.vent.trigger 'call:client:action', @model.get('extraPhone')

    onShow: ->
      @initComponents()
      @bind()

    initialize: (opts)->
      @model.view = @
      @model.lidModel = opts.lidModel 
      @model.errorValidation = []
      
    initComponents: ->
      @updateUI()
      @$("[name='extraPhone']").inputFilter 'phone'

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()

      @bindings = 
        extraPhone : '[name="extraPhone"]'

      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    modelDestroy: ->
      if @model.id then @model.destroy()
      else @model.trigger 'destroy', @model, @model.collection

    saveModel: ->
      @model.validate()
      if @model.errorValidation.length
        for error in @model.errorValidation
          if error.value == 'true' then @model.view.$("[name='" + error.name + "']").closest('div').addClass('has-error')
      else
        @model.view.$("[name='extraPhone']").closest('div').removeClass('has-error')
        @model.save()
      @model.errorValidation = []
      @model

  class View.ExtraPhoneEmptyView extends Air.BaseItemView
    template          : 'lid/extra/phoneempty'
    tagName           : 'tr'
  
  class View.ExtraPhoneAll extends Air.BaseCompositeView
    template         : 'lid/extra/phonelayout'
    itemView         : View.ExtraPhoneItem
    emptyView        : View.ExtraPhoneEmptyView
    itemViewContainer: "#phone"
