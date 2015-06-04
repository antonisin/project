@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.ExtraLidItemView extends Air.BaseItemView
    template          : 'lid/extralid/item'
    tagName           : 'tr'
    modelEvents: 
      'change' : 'saveModel'
      
    events:
      'click #destroy' : 'destroyModel'
      'click #globalExtraCall'  : -> App.vent.trigger 'call:client:action', @model.get('extraPhone')

    saveModel: ->
      @model.validate()
      if @model.errorValidation.length != 0
        for error in @model.errorValidation
          if error.value == 'true' then @model.view.$("[name='" + error.name + "']").closest('div').addClass('has-error')
      else
        @model.view.$("[name='extraEmail']", "[name='extraPhone']").closest('div').removeClass('has-error')
        if @model.isValid() then @model.save @model.attributes,
          wait:true
      @model.errorValidation = []
      @model

    destroyModel:  ->
      if @model.id then @model.destroy()
      else @model.trigger 'destroy', @model, @model.collection

    onShow: ->
      @initComponents()
      @bind()

    initialize: (opts)->
      @model.set('user_id',App.request 'get:current:user')
      @model.view = @
      @model.lidModel = opts.lidModel 
      @model.errorValidation = []

    initComponents: ->
      @updateUI()
      @$("[name='extraEmail']").inputFilter 'email'
      @$("[name='extraPhone']").inputFilter 'phone'
      @$("[name='extraFirstName'],[name='extraLastName']").inputFilter 'name'

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @bindings = 
          extraId        : { selector: '[name="extraId"]', converter: @getExtraId }
          extraFirstName : '[name="extraFirstName"]'
          extraLastName  : '[name="extraLastName"]'
          extraPhone     : '[name="extraPhone"]'
          extraEmail     : '[name="extraEmail"]'
          extraSex       : { selector: '[name="extraSex"]', converter: @extraSexBinder }
         
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    getExtraId: (d, v, a, m) ->
      m.collection.indexOf(m) + 1

    extraSexBinder: (d, v, a, m) ->
      if d is 'ModelToView'        
        _.defer =>  
          m.view.$("[name='extraSex']").closest('button').removeClass 'active'
          m.view.$("[name='extraSex']").closest('span').removeClass 'SexLabelWomen'
          m.view.$("[name='extraSex']").closest('span').removeClass 'SexLabelMale'
          m.view.$("[name='extraSex'][value='#{v}']").closest('button').addClass 'active' , true
          if v == "1" or v == 1 
            m.view.$("[name='extraSex'][value='#{v}']").closest('span').addClass 'SexLabelMale' , true
          if v == "2" or v == 2 
            m.view.$("[name='extraSex'][value='#{v}']").closest('span').addClass 'SexLabelWomen' , true
      v

  class View.ExtraLidEmptyView extends Air.BaseItemView
    template          : 'lid/extralid/empty'
    tagName           : 'tr'

  class View.ExtraLidAllView extends Air.BaseCompositeView
    template              : 'lid/extralid/layout'
    itemView              : View.ExtraLidItemView
    emptyView             : View.ExtraLidEmptyView
    itemViewContainer     : '#extra_item'