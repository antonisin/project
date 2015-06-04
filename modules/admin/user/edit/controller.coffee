@Air.module 'Admin.Users.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditController extends App.Base.Controller
    name: 'admin/users/edit'

    initialize: (opts) ->
      {@model, @collection} = opts
      @roles = App.request 'get:roles'
      @teams = App.request 'team:entities'

      @show @getView(),
        loading:
          entities: [@teams, @roles]

    getView: ->
      @view = new Edit.EditView
        model: @model
        roles: @roles
        teams: @teams

      @listenTo @model, 'validated:invalid', => App.execute 'notify:error', App.request('lang:get', 'usersaveerror')
      @listenTo @, 'ready:save', => @preValidation()

      @view

    preValidation: ->
      if document.getElementById('picture').files then file = document.getElementById('picture').files[0]

      if !@model.validate() and @processingFile(file) and @processPassword() and @emailPersist()
        if @model.hasChanged() and !@model.isNew()
          @onSave()
        else if @model.isNew()
          @onSave()
        else
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          $("#dialog").modal('hide')

    onSave: ->
      @model.save @model.attributes,
        wait:true
        success: =>
          $("#dialog").modal('hide')
          App.execute 'notify:success', App.request('lang:get', 'usersavesuccess')
          App.vent.trigger 'user:profile:dates:fetch'
          App.vent.trigger 'admin:user:sync'

    processPassword: ->
      password = @view.$el.find('#password').val()

      if password != ""
        @model.set('password', password)

      true

    emailPersist: ->
      find = @collection.where({'email': @model.get('email')})
      if find.length > 0 and find[0].id != @model.id
        @model.view.$('input[name="email"]').addClass 'has-error'
        @model.trigger 'validated:invalid'
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror2')
        return false
      @model.view.$('input[name="email"]').removeClass 'has-error'

      true

#    setAttr: ->
#      @model.set('role_id', @roles.where({system_name: @model.get('role')})[0].get('id'))

    processingFile: (file) ->
      console.log 1
      if file and  file.name != @model.get('picture')
        suffix = file.name.substr(file.name.length - 4,4)

        if suffix[0] is "." then name = @mtRand() + suffix
        else name = @mtRand() + '.' + suffix

        @model.set('picture', name)
        @upload file, name

      true

    upload:(file, name) ->
      xhr = new XMLHttpRequest()
      xhr.open("POST", Config.routePrefix + "user/upload", false)

      formData = new FormData()
      formData.append("file", file)
      formData.append("text", name)

      xhr.send(formData)

    mtRand:->
      max = 21474836472147483647
      Math.floor( Math.random() * (max+1) )