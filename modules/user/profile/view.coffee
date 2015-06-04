@Air.module 'User.Profile', (Profile, App, Backbone, Marionette, $, _) ->
  class Profile.DetailsView extends Air.BaseItemView
    template    : 'user/profile/details'
    className   : 'container'
    _modelBinder: undefined
    bindings    :
        thanks     : '[name="thanks"]'

    events:
      'click #edit'       : -> App.vent.trigger 'user:profile:edit', @model
      'click #thankyou'   : -> App.vent.trigger 'thankyou:show', @model

    initialize: (opts) ->
      @editable = opts.editable
      @model.view = @

    onShow: ->
      @bind()
      @$(".user_rating_test").raty
        score: @model.get('score')
        size: 40
        starType: 'i'
        click: (score) =>
          @update score

      @initComponents()
      if @model.get('about') == '' then @model.view.$('[id="about"]').hide()
      else @model.view.$('[id="about"]').show()

    update: (score) ->
      @model.set('score', score)
      @.model.save()

    initComponents: ->
      @$("#edit").show() if @editable
      @$("#thankyou").show() if not @editable
      @$("#thankyou").hide() if @editable
      @updateUI()
			
    bind: ->
      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @