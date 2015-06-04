@Air.module 'Admin.Users.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditView extends Air.BaseItemView
    template: 'admin/users/edit'
    _modelBinder: undefined
    templates:
      role      : HAML['_admin/users/select']

    events:
      'click #remove-img' :->
        @model.set("picture", "")
      'change [name="select"]' : (e) ->
        role = @roles.findWhere({system_name: @model.get('role')})
        @model.set 'role', role.get('system_name')

    dialog: ->
      title: if @model.isNew() then "Добавление пользователя" else "Редактирование пользователя #{@model.get('firstName')} #{@model.get('lastName')}"

    initialize: (opts)->
      $('body').find('#dialog').removeClass("modal-overflow")
      $('body').find('#dialog').addClass("modal-scroll")
      @model.view = @
      @roles = opts.roles

    templateHelpers: ->
      teamsHelper: @options.teams

    onShow: ->
      @initUI()

    initUI: ->
      $('body').find('#dialog').removeClass("modal-overflow")
      $('body').find('#dialog').addClass("modal-scroll")

      @updateUI()
      @renderRoles()
      @$("[name='email']").inputFilter 'email'
      @$("[name='phone']").inputFilter 'phone'
      @$("[name='addPhone']").inputFilter 'phone'
      @$("[name='firstName'],[name='lastName']").inputFilter 'name'
      @$('[name="priority"], [name="userLimit"]').inputFilter 'number'
      @$("#picture").filestyle
        buttonName: "btn-primary"

      @bind()
      @initDatePickers
        startDate: "-80y"
        endDate: "-10y"

    renderRoles : ->
      for role in @roles.models
        @$("#select").append @templates.role(role)

    bind: ->
      @bindings =
        firstName: '[name="firstName"]'
        lastName : '[name="lastName"]'
        priority : '[name="priority"]'
        userLimit: '[name="userLimit"]'
        email    : '[name="email"]'
        about    : '[name="about"]'
        picture  : '[name="picture-file"]'
        role     : '[name="select"]'
        phone    : '[name="phone"]'
        addPhone : '[name="addPhone"]'
        team     : '[name="team"]'
        birthdayFormatted   : '[name="birthdayFormatted"]'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @