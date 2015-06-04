@Air.module 'User.Dashboard.Header', (Header, App, Backbone, Marionette, $, _) ->

  class Header.HeaderView extends Air.BaseItemView
    template	: 'dashboard/header'
    className	: 'row'
    _modelBinder: undefined

    events:
      'click #offline'       :  'offline'
      'click #online'  		   :  'online' 
      'click #lunch'         : -> @decrement "lunch"
      'click #smoko'         : -> @decrement "smoko"
      'click #logout'        : -> App.execute 'goto', 'logout'
     
    onShow: ->
      @initComponents()
      if @counter.get('lunch') == 0
        $('#lunch').addClass('disabled') 
      if @counter.get('smoko') == 0
        $('#smoko').addClass('disabled') 
      @bind()

    initialize: (opts)-> 
      @counter = opts.counterModel
      
    initComponents: ->
      $('#online').addClass('active')  if @model.get('status') is true
      $('#offline').addClass('active') if @model.get('status') is  false
      @updateUI()
      
    online: (model)  ->
    	@model.set('status','true')
    	@trigger 'click:save', @model

    offline: ->
    	@model.set('status','false') 
    	@trigger 'click:save', @model
    	
    decrement: (string) ->
      if @counter.get(string) > 0
        @counter.set(string, @counter.get(string) - 1)
        @counter.save()
      if @counter.get(string) < 1
        $('#' + string).addClass('disabled') 

    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @bindings = 
        smoko: '[name="smoko"]'
        lunch: '[name="lunch"]'

      @_modelBinder.bind @counter, @el, @bindings
      Backbone.Validation.bind @




    
      
  