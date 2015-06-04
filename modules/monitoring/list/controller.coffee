@Air.module 'Monitoring.List', (List, App, Backbone, Marionette, $, _) ->
  class List.Controller extends App.Base.Controller
    _name: 'monitoring/list'

    initialize: ->
      inline  = App.request 'monitoring:inline:entity'
      inorder = App.request 'monitoring:inorder:entity'
      outline = App.request 'monitoring:outline:entity'
      @layout = new List.Layout

      @listenTo App.vent, 'menu:choose', (name)-> clearInterval(@interval)

      @listenTo @layout, 'show', =>
        @getInlineView inline
        @getInorderView inorder
        @getOutlineView outline
      @fetchCollection inline, inorder, outline

      @show @layout,
        loading:
          entities: [inline, inorder, outline]
          
      @listenTo App.vent, 'monitoring:comment:sync', =>
        @view.trigger 'refresh'

    fetchCollection: (inline, inorder, outline) ->
      @interval = setInterval ->
        inline.fetch({reset: true})
        inorder.fetch({reset: true})
        outline.fetch({reset: true})
      ,3000

    getInlineView: (inline) ->
      view = new List.ListCompositeView
        collection: inline
        className: 'inline'
      @layout.inline.show view

      @listenTo view, 'childview:monitoring:click:archive', (view) ->
        clearInterval(@interval)
        App.vent.trigger 'monitoring:archive' , view.model

      @listenTo view, 'childview:asterisk:click:listen', (view, model) ->
        @listenAction model.get('cidNum'), App.currentUser.get('email'), 'listen'

      @listenTo view, 'childview:asterisk:click:whisper', (view, model) ->
        @listenAction model.get('cidNum'), App.currentUser.get('email'), 'whisper'

      @listenTo view, 'childview:asterisk:click:barge', (view, model) ->
        @listenAction model.get('cidNum'), App.currentUser.get('email'), 'barge'

      @listenTo view, 'childview:asterisk:click:hangup', (view, model) ->
        @listenAction model.get('cidNum'), null, 'hangup'
      view

    getInorderView: (inorder) ->
      view = new List.ListCompositeView
        collection: inorder
        className: 'inorder'
      @layout.inorder.show view

      @listenTo view , 'childview:monitoring:click:archive', (view) ->
        App.vent.trigger 'monitoring:archive' , view.model
      view

    getOutlineView: (outline) ->
      view = new List.ListCompositeView
        collection: outline
        className: 'outline'

      @layout.outline.show view

      @listenTo view , 'childview:monitoring:click:archive', (view) ->
        App.vent.trigger 'monitoring:archive' , view.model

      view

    listenAction: (agent, supervisor, action) ->
      xhr = new XMLHttpRequest()
      xhr.open("POST", Config.routePrefix + "asterisk/" + action, false)

      formData = new FormData()
      formData.append("supervisor", supervisor)
      formData.append("agent", agent)

      xhr.send(formData)