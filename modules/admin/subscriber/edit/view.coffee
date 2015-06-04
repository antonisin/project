@Air.module 'Admin.Subscriber.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template    : 'admin/subscriber/edit'
    _modelBinder: undefined

    dialog: ->
      title: if @model.isNew() then "Добавление подписчика" else "Редактирование подписчика"

    initialize: ->
      @model.view = @

    onShow: ->
      @updateUI()
      @bind()

    bind: ->
      @bindings = 
        email : '[name="email"]'
        isActive : { selector: '[name="isActive"]' , converter: @activeBinder }
        
      @_modelBinder = new Backbone.ModelBinder()
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
    