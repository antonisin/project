@Air.module 'User.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditController extends App.Base.Controller

    initialize: (opts) ->
      { model } = opts

      if parseInt(model.id) isnt App.request('get:current:user').id
        App.execute 'notify:error', App.request('lang:get', 'userediterror')
      else
        @view = @getView model
      
        @listenTo model, 'validated:invalid', => App.execute 'notify:error', App.request('lang:get', 'usersaveerror')
        @listenTo @view, 'dialog:click:save', => @preValidation model
        @show @view

    getView: (model) ->
      new Edit.EditView
        model: model

    preValidation: (model) ->
      file = document.getElementById('picture').files[0]
      if model.hasChanged() or file then @preValidationFile model, file
      else 
        App.execute 'notify:info', App.request('lang:get', 'nothing:changed') 
        $("#dialog").modal('hide')

    preValidationFile: (model, file) ->
      if file and model.get('picture') isnt file.name
        name = file.name.substr(file.name.length-4,4)

        if name[0] is "." then name= @mtRand() + name
        else name = @mtRand() + '.' + name
        if file.name == "" then name = ""

        model.set('picture', name)
        @upload file, name
      @onSave model, file
        
    onSave: (model) ->
      model.save()

      if model.isValid()
        $("#dialog").modal('hide')
        App.execute 'notify:success', App.request('lang:get', 'usersavesuccess')
        App.vent.trigger 'user:profile:dates:fetch'

    upload:(file, name) ->
      xhr = new XMLHttpRequest()
      xhr.open("POST", Config.routePrefix + "user/upload", false)
    
      formData = new FormData()
      formData.append("file", file)
      formData.append("text", name)
    
      xhr.send(formData)
      
    sleep: (ms) ->
      ms+= new Date().getTime()
      while new Date() < ms
            {}
    mtRand:->
      max = 21474836472147483647
      Math.floor( Math.random() * (max+1) )
