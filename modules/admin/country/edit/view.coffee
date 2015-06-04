@Air.module 'Admin.Country.Edit', (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.EditView extends Air.BaseItemView
    template: 'admin/country/edit'
    _modelBinder: undefined

    templateHelpers: ->
      locales: _.map App.request('locales:list'), (el) ->
        name: App.request 'lang:get', "locale_#{el}"
        code: el

    dialog: ->
      title: if @model.isNew() then App.request('lang:get', 'country:title:add') else App.request('lang:get', 'country:title:edit', [@model.id])

    onShow: ->
      @updateUI()
      @bind()
      @$("[name='code2'],[name='code3']").inputFilter 'latin'

    bind: ->
      bindings =
        code2: '[name="code2"]'
        code3: '[name="code3"]'

      for locale in App.request 'locales:list'
        bindings["name_#{locale}"] = "[name='name_#{locale}']"

        if locale != 'ru'
          @$("[name='name_#{locale}']").inputFilter 'latin'

      @_modelBinder = new Backbone.ModelBinder()
      @_modelBinder.bind @model, @el, @bindings
      Backbone.Validation.bind @
  