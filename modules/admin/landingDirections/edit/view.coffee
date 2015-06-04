@Air.module 'Admin.LandingDirections.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditView extends Air.BaseItemView
    template    : 'admin/landingDirections/edit'
    _modelBinder: undefined

    dialog: -> title: App.request('lang:get', 'landing:title:add')
    initialize: ->  @model.view = @
    
    onShow: ->
      @updateUI()
      @$("#picture").filestyle 
        buttonName: "btn-primary"
      @bind()

    bind: ->
      @bindings = 
        name      : '[name="name"]'
        image     : '[name="image"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @