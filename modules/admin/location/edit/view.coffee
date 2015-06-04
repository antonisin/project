@Air.module 'Admin.Location.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseLayout
    template: 'admin/location/edit'
    _modelBinder: undefined

    templateHelpers: ->
      locales: _.map App.request('locales:list'), (el) ->
        name: App.request 'lang:get', "locale_#{el}"
        code: el
      countries: @countries

    regions:
      airports  : '#airports'

    ui:
      'city'    : '#city'
      'airports': '#airports'
  
    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'location:title:add') else App.request('lang:get', 'location:title:edit', [@model.id])

    initialize: (opts) ->
      { @countries } = opts

    onShow: ->
      @updateUI()
      @initLocationPickers
        selector        : "[name='city']",
        url             : Config.routePrefix + "locations/cities?id=#{@model.id}"
        dropdownCssClass: ""
        allowClear      : false
      @bind()

    bind: ->
      @model.view = @

      bindings =
        code    : '[name="code"]'
        country : '[name="country"]'
        is_city : {selector: '[name="is_city"]', converter: @isCityBinder}
        city    : {selector: '[name="city"]', converter: @cityBinder}
    
      for locale in App.request 'locales:list'
        bindings["name_#{locale}"] = "[name='name_#{locale}']"

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, bindings
      Backbone.Validation.bind @, 
        invalid: (view, attr, error, sel) ->
          view.$("[name='#{attr}']").closest('div').addClass('has-error')
        valid: (view, attr, error, sel) ->
          view.$("[name='#{attr}']").closest('div').removeClass('has-error')
  
    isCityBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        if v is "0" 
          m.validation.city.required = true
          m.view.ui.city.slideDown 200 
          m.view.ui.airports.slideUp 200
        else
          m.validation.city.required = false
          m.view.ui.city.slideUp 200
          m.view.ui.airports.slideDown 200
      v

    cityBinder: (d, v, a, m) ->
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
