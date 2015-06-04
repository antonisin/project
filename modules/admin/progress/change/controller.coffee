@Air.module 'Admin.Progress.Change', (Change, App, Backbone, Marionette, $, _) ->

  class Change.Controller extends App.Base.Controller

    initialize: ->
      @layout = @getLayout()
      @listenTo @layout, 'validation:model:is:valid', => @saveModel()
      @layout.on 'show', =>
        value = @model.get('type')
        @showTypes parseInt(value)
        @showRanges parseInt(value)
        @showRank parseInt(value)

      @listenTo @model, 'change:type', (model, value) =>
        console.log model
        @model.set
          'rank': ''
          'range':''
        if parseInt(value) == 4
#          @model.set('range', 0)
          @model.set('rank', 0)
        @showRanges value
        @showRank value
        @layout.bind()

      @show @layout

    getLayout: ->
      new Change.Layout model: @model

    showTypes: ->
      view = new Change.ItemView
        array: window.data.progress
        field: 'type'
      @layout.types.show view

    showRanges: (index) ->
      view = new Change.ItemView
        array: window.data?.progress[index]?.range
        field: 'range'
      @layout.ranges.show view

    showRank: (index) ->
      view = new Change.ItemView
        array: window.data?.progress[index]?.rank
        field: 'rank'
      @layout.values.show view

    saveModel: ->
      file = document?.getElementById('picture')?.files[0]
      if file
        suffix = file.name.substr(file.name.length - 4,4)

        if suffix[0] is "." then name = @mtRand() + suffix
        else name = @mtRand() + '.' + suffix

        @model.set('image', name)
        @sendFile file, name
      if (!file and @model.id) or file
        @save()
        @close()

    sendFile: (file, name) ->
      formData = new FormData()
      formData.append("file", file)
      formData.append("text", name)

      xhr = new XMLHttpRequest()
      xhr.open("POST", Config.routePrefix + "user/upload", false)
      xhr.send(formData)

    mtRand:->
      max = 21474836472147483647
      Math.floor( Math.random() * (max+1) )
