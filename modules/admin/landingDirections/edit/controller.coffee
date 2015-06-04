@Air.module 'Admin.LandingDirections.Edit', (Edit, App, Backbone, Marionette, $, _) ->
  class Edit.EditController extends App.Base.Controller
    name: 'admin/langingDirections/edit'

    initialize: (opts) ->
      @model = opts.model
      @view = @getView()
      @show @view,
        loading:
          type: 'opacity'
          entities: [@model]

    getView: ->
      view = new Edit.EditView
        model     : @model

      @listenTo @, 'ready:save',  =>
        if @model.hasChanged() or @model.isNew()
          @preValidation()
        else if !@model.hasChanged() and !@model.isNew()
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          @close()
        if @model.isValid() then @model.validation.image.required = false

      view

    preValidation: ->
      file = document.getElementById('picture').files[0]
      if file
        name = file.name.substr(file.name.length-4,4)

        if  name[0] is "." then name = @mtRand() + name
        else name = @mtRand() + '.'+  name

        if file.name == "" then name = ""

        @model.set('image', name)
        @upload file, name

      @save()

    save: ->
      @model.validate()
      if @model.isValid()
        @loading()
        @model.save @model.attributes,
          wait: true,
          success: =>
            @loading()
            App.vent.trigger 'admin:landing:directions:sync'
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')

    upload:(file, name) ->
      xhr = new XMLHttpRequest()
      xhr.open("POST", Config.routePrefix + "landing/upload", false)

      formData = new FormData()
      formData.append("file", file)
      formData.append("text", name)

      xhr.send(formData)

    mtRand:->
      max = 21474836472147483647
      Math.floor( Math.random() * (max+1) )