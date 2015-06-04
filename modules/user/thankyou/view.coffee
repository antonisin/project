@Air.module 'User.Thankyou', (Thankyou, App, Backbone, Marionette, $, _) ->
  class Thankyou.ThankyouView extends Air.BaseItemView
    template    : 'user/thankyou/thankyou'
    _modelBinder: undefined

    dialog      :
        title     : 'Сказать спасибо'

    events      : 
      'submit form': (e) -> 
        e.preventDefault()
        @trigger 'click:save', @model
        false

      'keydown textarea' : 'keyup'

      'keyup textarea' : 'keyup'

    onShow: ->
      @initComponents()
      @number = 260
      @$('#textarea_number').html(@number)
      @bind()

    onClose: ->
      @$el.popover 'destroy'

    keyup: (e) ->
      @$('#textarea_number').html(@number - @$('#textarea_content').val().length) 
      if @$('#textarea_number').html() < 20 
        @$('#textarea_number').addClass('number_error') 
      else 
        @$('#textarea_number').removeClass('number_error')

    initComponents: ->
      @updateUI()
      
    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

  