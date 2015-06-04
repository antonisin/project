@Air.module 'Admin.Landings.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.LandingView extends Air.BaseItemView
    template   : 'admin/landing/edit/landing'
    templates  :
      direction: HAML['_admin/landing/add/direction']

    modelEvents:
      'change'  : 'save'

    events:
      'click #add' : -> @trigger 'landing:item:add', @model

    initialize: (opts) ->
      @model      = opts.model
      @model.view = @
      @directions = opts.directions

    onShow: ->
      @updateUI()
      @initLocationPickers
        selector        : "[name='location']",
        dropdownCssClass: ""
        allowClear      : false
      @renderDirections()
      @bind()
      @$("input[name='price']").inputFilter 'number'

    renderDirections: ->
      for dir in @directions.models
        @$('#direction').append @templates.direction(dir)

    save: ->
      @model.validate()
      if @model.isValid()
        @model.save()

    bind: ->
      @bindings =
        url      : '[name="url"]'
        direction: '[name="direction"]'
        price    : '[name="price"]'
        isPublic : { selector: '[name="isPublic"]', converter: @publicBinder }
        location : { selector: '[name="location"]', converter: @locationBinder }

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    publicBinder: (d, v, a, m) ->
      if d is 'ModelToView'
        _.defer =>
          m.view.$("[name='isPublic']").closest('button').removeClass 'active'
          m.view.$("[name='isPublic']").closest('span').removeClass 'ActiveLabelOn'
          m.view.$("[name='isPublic']").closest('span').removeClass 'ActiveLabelOff'
          m.view.$("[name='isPublic'][value='#{v}']").closest('button').addClass 'active' , true
          if v == 1 or v == '1'
            m.view.$("[name='isPublic'][value='#{v}']").closest('span').addClass 'ActiveLabelOn' , true
          if v == 0 or v == '0'
            m.view.$("[name='isPublic'][value='#{v}']").closest('span').addClass 'ActiveLabelOff' , true
      v

    locationBinder: (d, v, a, m) ->
      $el = m.view.$("[name='#{a}']").closest('.form-group')
      model = m.get("#{a}")

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
        m.set(a,model)

      unless v is ''
        $el.find("input[name='#{a}']").attr 'data-code', code
        $el.find("input[name='#{a}']").attr 'data-name', name
        $el.find("[id*='#{a}-select']").select2 "val", v
      v

  class Edit.LandingItem extends Air.BaseItemView
    template  : 'admin/landing/edit/item'
    className : 'col-md-6'

    modelEvents:
      'change' : 'save'

    events:
      'click #destroy' : -> @trigger 'landing:item:delete', @model

    initialize: (opts) ->
      @landing    = opts.landing
      @model.view = @

    onShow: ->
      @updateUI()
      @initLocationPickers
        selector        : "[name='location']",
        dropdownCssClass: ""
        allowClear      : false
      @initAirlinePickersSpecial
        selector        : ".airline"
        allowClear      : false
      @landingLocationBinder()
      @bind()
      @$("input[name='price1'], input[name='price2'], input[name='price3'], input[name='price4']").inputFilter 'number'

    bind: ->
      @bindings =
        itemId  : { selector: '[name="itemId"]', converter: @getItemId }
        price1  : '[name="price1"]'
        price2  : '[name="price2"]'
        price3  : '[name="price3"]'
        price4  : '[name="price4"]'
        airline1 : {selector: '[name="airline1"]', converter: @locationBinder }
        airline2 : {selector: '[name="airline2"]', converter: @locationBinder }
        airline3 : {selector: '[name="airline3"]', converter: @locationBinder }
        airline4 : {selector: '[name="airline4"]', converter: @locationBinder }
        location : {selector: '[name="location"]', converter: @locationBinderCode }
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @

    landingLocationBinder: ->
      bindings =
        location : {selector: '[name="landinglocation"]', converter: @locationLandingBinder }

      @_modelBinderLanding = new Backbone.ModelBinder()
      @_modelBinderLanding.bind @landing, @el, bindings
      Backbone.Validation.bind @

    getItemId:(d, v, a, m) ->
      m.collection.indexOf(m) + 1

    save: ->
      @model.validate()
      if @model.isValid() then @model.save()

    locationLandingBinder: (d, v, a, m) ->
      v.code

    locationBinderCode: (d, v, a, m) ->
      $el = m.view.$("[name='#{a}']").closest('.form-group')
      model = m.get("#{a}")

      if d is 'ModelToView'
        if model
          code = model.code
          name = ''
        else
          code = ''
          name = ''
      else
        code = $el.find(".select2-chosen").html().substr 0, 3
        name = $el.find(".select2-chosen small").html()

        model = {id: v, code: code, name: name}
        m.attributes["#{a}"] = model

      unless v is ''
        $el.find("input[name='#{a}']").attr 'data-code', code
        $el.find("input[name='#{a}']").attr 'data-name', name
        $el.find("[id*='#{a}-select']").select2 "val", v
      v

    locationBinder: (d, v, a, m) ->
      $el = m.view.$("[name='#{a}']").closest('.form-group')
      model = m.get("#{a}")

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
        m.attributes["#{a}"] = model

      unless v is ''
        $el.find("input[name='#{a}']").attr 'data-code', code
        $el.find("input[name='#{a}']").attr 'data-name', name
        $el.find("[id*='#{a}-select']").select2 "val", v
      v


  class Edit.LandingItems extends Air.BaseCompositeView
    template          : 'admin/landing/edit/itemlayout'
    itemView          :  Edit.LandingItem
    itemViewContainer : '#item'
    className         : 'col-md-12'

    initialize: (opts) ->
      @landing    = opts.landing
      @collection = opts.collection