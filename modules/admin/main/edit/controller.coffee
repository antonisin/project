@Air.module 'Admin.Main.Add', (Add, App, Backbone, Marionette, $, _) ->
  class Add.AddSliderController extends App.Base.Controller
    name: 'admin/main/slideradd'

    initialize: ->
      if !@model  then @model = App.request 'admin:main:slider:new:model'
      @show @getView @model

    getView:  ->
      view = new Add.AddSliderView
        model: @model

      @listenTo view, 'dialog:click:save', => @process()

      view

    process: ->
      if !@model.validate()
        file = document.getElementById('picture').files[0]
        data = file.name.substr(file.name.length-4,4)
        if  data[0] is "." then data = @mtRand() + data
        else data = @mtRand() + '.'+  data
        @upload file, data

        $("#dialog").modal('hide')
        App.vent.trigger 'admin:slider:fetch'
        App.execute 'notify:success', App.request('lang:get', 'slider:save:success')
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')

    upload: (file, data) ->
      xhr = new XMLHttpRequest()
      xhr.open("POST", Config.routePrefix + "main/slider/upload", false)

      formData = new FormData()
      formData.append("file", file)
      formData.append("data", data)

      xhr.send(formData)

    mtRand:->
      max = 21474836472147483647
      Math.floor( Math.random() * (max+1) )


  class Add.AddTestimonialController extends App.Base.Controller
    name: 'admin/main/testimonialadd'

    initialize: (opts) ->
      if opts.model then @model = opts.model else @model = App.request 'admin:main:testimonial:new:model'
      @view = @getView @model
      @show @view

    getView: (model) ->
      view = new Add.AddTestimonialView
        model: model

      @listenTo @, 'ready:save', =>
         if view.model.hasChanged() or model.isNew()
           @save model
         else if !model.hasChanged()
          App.execute 'notify:info', App.request('lang:get', 'nothing:changed')
          @close()

      view

    save: ->
      if !@model.validate()
        @loading()
        @model.save @model.attributes,
          wait:true
          success:  =>
            @loading()
            App.vent.trigger 'admin:main:testimonial:sync'
            App.execute 'notify:success', App.request('lang:get', 'data:save:success')
            @close()
      else
        App.execute 'notify:error', App.request('lang:get', 'usersaveerror')
