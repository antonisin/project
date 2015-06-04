@Air.module 'Admin.Landings.Add', (Add, App, Backbone, Marionette, $, _) ->
  class Add.AddView extends Air.BaseItemView
    template    : 'admin/landing/add/view'
    _modelBinder: undefined

    templates:
      direction: HAML['_admin/landing/add/direction']

    dialog: ->
      title: App.request('lang:get', 'landing:title:add')
    
    initialize: (opts) ->
      @directions = opts.directions
      @model      = opts.model
      @model.view = @
    
    onShow: ->
      @updateUI()
      @renderDirections()
      @initLocationPickers
        selector        : "[name='location']",
        dropdownCssClass: ""
        allowClear      : false
      @bind()
      @$("input[name='price']").inputFilter 'number'

    bind: ->
      @bindings = 
          url      : '[name="url"]'
          direction: '[name="direction"]'
          price    : '[name="price"]'
          location : { selector: '[name="location"]',  converter: @locationBinder }

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    renderDirections: ->
      for dir in @directions.models
        @$('#direction').append @templates.direction(dir)

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