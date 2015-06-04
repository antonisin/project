@Air.module 'Lid.View', (View, App, Backbone, Marionette, $, _) ->

  class View.HistoryItemView extends Air.BaseLayout
    template: 'lid/history/item'
    _modelBinder: undefined

    regions:
      comments: '.comments'

    initialize: (opts) ->
      @template = 'lid/history/' + opts.model.get('historyTypeModel').code

    onShow: ->
      App.request 'lid:view:history',
        collection: App.request 'history:comments', @model.id, @model.get 'comments'
        region: @comments

      @$('.pop').popover()

    events:
      'click .minimize-activity'      : 'expand'
      'click .maximize-activity'      : 'expand'
      'click .add-comment'            : 'save'

    modelEvents:
      'sync'                       : 'render'

    onDomRefresh: ->
      @$('.pop').popover()

    onClose: ->
      @$('.pop').popover('destroy').popover()

    save: ->
      el = @$ '[name="commentText"]'
      if el.val() is ''
        el.addClass 'has-error'
      else
        @trigger 'new:comment', el.val()
        @$('.pop').popover('destroy')

    expand: ->
      @$('.full-activity').toggleClass('hide')
      @$('.comments-list').toggleClass('hide')
      @$('.minimize-activity').toggleClass('hide')
      @$('.maximize-activity').toggleClass('hide')

  class View.HistoryEmptyView extends Air.BaseItemView
    template: 'lid/history/empty'
    tagName: 'tr'

  class View.HistoryListView extends Air.BaseCompositeView
    template              : 'lid/history/layout'
    itemView              : View.HistoryItemView
    emptyView             : View.HistoryEmptyView
    itemViewContainer     : '#history_item'

    events:
      'click .activity-list'      : 'expand'

    expand: ->
      @$('.activity-i').toggleClass('fa-chevron-up fa-chevron-down')
      @$('#history_item').toggleClass('hide')

    initialize: ->
      @listenTo @collection, 'sync', -> @render()
