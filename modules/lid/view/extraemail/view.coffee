@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ExtraEmailItem extends Air.BaseItemView
    template: 'lid/extra/email'
    tagname : 'div'
    modelEvents: 
      'change' : 'saveModel'
    events:
      'click .email_remove' :'modelDestroy'

    onShow: ->
      @initComponents()
      @bind()

    initialize: (opts)->
      @model.view = @
      @model.lidModel = opts.lidModel 
      @model.errorValidation = []

    initComponents: ->
      @updateUI()
      @$("[name='extraEmail']").inputFilter 'email'

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()

      @bindings =
        extraEmail : '[name="extraEmail"]'

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
        if @model.isValid()
          @model.view.$("[name='extraEmail']").closest('div').removeClass('has-error')
          @model.save()
          # @model.save wait:true
      @model.errorValidation = []
      @model

  class View.ExtraEmailEmptyView extends Air.BaseItemView
    template          : 'lid/extra/emailempty'
    tagName           : 'tr'

  class View.ExtraEmailAll extends Air.BaseCompositeView
    template         : 'lid/extra/emaillayout'
    itemView         : View.ExtraEmailItem
    emptyView        : View.ExtraEmailEmptyView
    itemViewContainer: "#email"
