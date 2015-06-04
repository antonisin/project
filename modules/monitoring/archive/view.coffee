@Air.module 'Monitoring.Archive', (Archive, App, Backbone, Marionette, $, _) ->

  class Archive.ItemView extends Air.BaseItemView
    template          : 'monitoring/archive/item'
    tagName           : 'tr'
    events:
      'click #comment':-> @trigger 'monitoring:archive:click:comment', @model
      'click #tag':-> @trigger 'monitoring:archive:click:tag', @model

    templateHelpers: ->
      tag: @tag

    onShow: ->
      audiojs.create @$el.find('audio')

    initialize: (opts)->
      if  opts.tags.findWhere({'id': @model.get('tagId')})
        @tag = opts.tags.findWhere({'id': @model.get('tagId')}).get('name')

  class Archive.EmptyView extends Air.BaseItemView
    template          : "monitoring/archive/empty"
    tagName           : "tr"

  class Archive.CompositeView extends Air.BaseCompositeView
    template              : 'monitoring/archive/list'
    itemView              : Archive.ItemView
    emptyView             : Archive.EmptyView
    itemViewContainer     : 'tbody'
    className             : 'archive'

    initialize: ->
      @listenTo @, 'refresh', @render

    onShow: ->
      App.Utils.DT.initDT @$('table'),
        searching: false
        processing: false
      @updateUI()
      App.vent.trigger 'dialog:position:update'
