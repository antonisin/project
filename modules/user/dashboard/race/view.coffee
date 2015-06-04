@Air.module 'User.Dashboard.Race', (Race, App, Backbone, Marionette, $, _) ->

  class Race.Layout extends Air.BaseLayout
    template  : 'dashboard/race/layout'
    className : 'portlet box blue tabbable message_tab'
    regions:
      queue   : "#queue"

  class Race.QueueEmptyView extends Air.BaseItemView
    template  : 'dashboard/race/empty'
    className : 'tr'

  class Race.QueueItemView extends Air.BaseItemView
    template  : 'dashboard/race/item'
    tagName   : 'tr'
    popover   : HAML['_dashboard/race/popover']
    title     : HAML['_dashboard/race/title']
    attributes:
      'data-container'  : 'body'
      'data-toggle'     : "popover"

    events:
      'shown.bs.popover': -> 
        $(".popover #close").on 'click', => @$el.popover 'hide' 
        $(".popover #profile").on 'click', => @trigger 'click:profile', @model

    initialize: (opts) ->
      @model.set 'position', opts.position+1
      @listenTo

    onShow: ->
      @$el.attr 'data-content', @popover @model.attributes
      @$el.attr 'data-title', @title @model.attributes
      @$el.popover
        html: true

    onClose: ->
      @$el.popover 'destroy'

  class Race.QueueCollectionView extends Air.BaseCompositeView
    template  : 'dashboard/race/race'
    tagName   : 'table'
    className : 'table table-striped table-bordered table-advance table-hover table-interactive'
    itemView  : Race.QueueItemView
    emptyView : Race.QueueEmptyView
    itemViewContainer: 'tbody'
    itemViewOptions: (model) ->
      position: @collection.indexOf model

    onShow: ->
      $(".badge-info").append(@collection.length)