@Air.module 'Admin.Main.Add', (Add, App, Backbone, Marionette, $, _) ->
  class Add.AddSliderView extends Air.BaseItemView
    template: 'admin/main/slideradd'
    _modelBinder: undefined

    dialog: ->
      title: "Добавление картинки для слайдера"

    onShow: ->
      @$("#picture").filestyle 
        buttonName: "btn-primary"
      @bind()
    bind: ->
      @bindings = 
        url           : '[name="url"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

  class Add.AddTestimonialView extends Air.BaseItemView
    template: 'admin/main/testimonialadd'
    _modelBinder: undefined
    events:
      'keyup textarea'   : 'keyup'

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'testimonial:title:add') else App.request('lang:get', 'testimonial:title:edit', [@model.id])

    initialize: ->
      @model.view = @

    onShow: ->
      @initLocationPickers
        dropdownCssClass: ""
        allowClear      : false
      @bind()
      @$("[name='name']").inputFilter 'name'

    bind: ->
      @bindings = 
        name : '[name="name"]'
        text  : '[name="text"]'
        startLocation : {selector: '[name="startLocation"]', converter: @locationBinder }
        endLocation : {selector: '[name="endLocation"]', converter: @locationBinder }

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    keyup: (e) ->
      @$('#number').html(e.target.value.length)
        
    locationBinder: (d, v, a, m) ->
      $el = m.view.$("[name='#{a}']").closest('.form-group')
      model = m.get("#{a}Model")
        
      if d is 'ModelToView'
        if model
          code = model.code
          name = model.name
        else
          code = ''
          name = '-'
      else
        code = $el.find(".select2-chosen").html().substr 0, 3
        name = $el.find(".select2-chosen small").html()

        model = {id: v, code: code, name: name}
        m.attributes["#{a}Model"] = model

      unless v is ''
        $el.find("input[name='#{a}']").attr 'data-code', code
        $el.find("input[name='#{a}']").attr 'data-name', name
        $el.find("[id*='#{a}-select']").select2 "val", v
      
      v