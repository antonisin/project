@Air.module 'User.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template    : 'user/edit/edit'
    tagName     : 'form'
    className   : 'form-horizontal'
    _modelBinder: undefined

    dialog      :
      title: 'Редактирование профиля'
    events      : 
      'submit form': -> 
        @trigger 'click:save', @model
        false
      'click #remove-img' :->  
        @model.set("picture", "")
        
    onShow: ->
      @initComponents()
      @bind()

    initialize:->
      $('body').find('#dialog').removeClass("modal-overflow")
      $('body').find('#dialog').addClass("modal-scroll")

    initComponents: ->
      @updateUI()

      $('body').find('#dialog').removeClass("modal-overflow")
      $('body').find('#dialog').addClass("modal-scroll")
      $("#picture").filestyle({buttonName: "btn-primary"});

      @$("[name='email']").inputFilter 'email'
      @$("[name='phone'], [name='addPhone']").inputFilter 'phone'
      @$("[name='firstName'],[name='lastName']").inputFilter 'name'
      @initDatePickers 
        startDate: "-80y"
        endDate: "-10y"

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      
      @bindings = 
        firstName           : '[name="firstName"]'
        picture             : '[name="picture-file"]'
        lastName            : '[name="lastName"]'
        email               : '[name="email"]'
        birthdayFormatted   : '[name="birthdayFormatted"]'
        about               : '[name="about"]'
        phone               : '[name="phone"]'
        addPhone            : '[name="addPhone"]'

      @_modelBinder.bind @model, @el, @bindings 
      Backbone.Validation.bind @
      
   
      
      

  