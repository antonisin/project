@Air.module 'Admin.Main.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Layout extends Air.BaseLayout
    template: 'admin/main/layout'
    className: 'gray_block_bg'
    regions:
      slider      : '#slider'
      travel      : '#travel'
      testimonial : '#testimonial'

  class List.SliderItem extends Air.BaseItemView
      template : 'admin/main/slideritem'
      className: 'col-md-4'
      events:
        'click #remove' : 'modelDestroy'

      modelEvents: 
        'change' : 'saveModel'

      modelDestroy: ->
        @trigger 'slider:model:destroy', @

      onShow: ->
        @model.view = @
        @updateUI()
        @bind()

      bind: ->
        @_modelBinder = new Backbone.ModelBinder()
        @bindings =
          isActive : { selector: '[name="isActive"]' , converter: @activeBinder }
        @_modelBinder.bind @model, @el, @bindings
        Backbone.Validation.bind @

      activeBinder: (d, v, a, m) ->
        if d is 'ModelToView'     
          _.defer =>  
            m.view.$("[name='isActive']").closest('button').removeClass 'active'
            m.view.$("[name='isActive']").closest('span').removeClass 'ActiveLabelOn'
            m.view.$("[name='isActive']").closest('span').removeClass 'ActiveLabelOff'
            m.view.$("[name='isActive'][value='#{v}']").closest('button').addClass 'active' , true
            if v == 1 or v == '1'
              m.view.$("[name='isActive'][value='#{v}']").closest('span').addClass 'ActiveLabelOn' , true
            if v == 0 or v == '0'
              m.view.$("[name='isActive'][value='#{v}']").closest('span').addClass 'ActiveLabelOff' , true
        v
     
      saveModel: ->
        @model.validate()
        if @model.isValid
          @model.save()
        @model

  class List.Slider extends Air.BaseCompositeView
    template         : 'admin/main/slider'
    itemView         : List.SliderItem
    className        : 'row'
    events :
      'click .sliderAdd' : -> @trigger 'admin:main:slider:add'

  class List.TravelItem extends Air.BaseItemView
    template: 'admin/main/travelitem'
    className        : 'row'
    modelEvents: 
      'change' : 'saveModel'

    onShow: ->
      @bind()
    
    bind: ->
      @bindings = 
        order: '[name="order"]'
        text : '[name="text"]'
      @_modelBinder= new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
    
    saveModel: ->
      @model.validate()
      if @model.isValid
        @model.save()
      @model

  class List.Travel extends Air.BaseCompositeView
    template         : 'admin/main/travel'
    itemView         : List.TravelItem
    className        : 'travelCollection'

    onShow: ->
      @$el.sortable
        stop:=>
          _this.trigger 'admin:travel:sortable', _this.$('.col-md-12')

  class List.TestimonailItem extends Air.BaseItemView
    template: 'admin/main/testimonialitem'
    tagName   : 'tr'
    events:
      'click #delete' : -> @trigger 'testimonial:delete:model', @model 
      'click #edit'   : -> @trigger 'testimonial:edit:model', @model
      'click td:not(".actions-cell")'      : -> @trigger 'testimonial:edit:model', @model

  class List.Testimonial extends Air.BaseCompositeView
    template  : 'admin/main/testimonial'
    itemView  : List.TestimonailItem
    itemViewContainer : 'tbody'
    triggers:
      'click #add'        : 'admin:main:testimonial:add'

    initialize: (model) ->
      @listenTo @, 'refresh', @render
      
    onRender:->
      @initDT()

    initDT: ->
      App.Utils.DT.initDT '#lidstable', 
        sort: [0, 'asc']
        initComplete: (=> @$("#add").prependTo @$("#lidstable_wrapper .row:first .col-md-6:last"))
